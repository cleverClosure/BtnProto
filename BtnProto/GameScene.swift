//
//  GameScene.swift
//  BtnProto
//
//  Created by Tim Isaev on 10.12.2019.
//  Copyright © 2019 Tim Isaev. All rights reserved.
//

import SpriteKit
import GameplayKit



class GameScene: SKScene {
    
    let grid = Grid()
    
    var levelUserResponseDelegate: LevelUserResponseDelegate?
    
    var edgeInsets: UIEdgeInsets! {
        didSet {
            if oldValue == nil {
                addRestart()
            }
        }
    }
    
    lazy var center: CGPoint = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
    
    let levelData: [[LNode]]
    let background: SKSpriteNode
    let restartButton = SKSpriteNode(imageNamed: "restart")
    
    
    init(size: CGSize, levelData: [[LNode]], background: SKSpriteNode) {
        self.levelData = levelData
        self.background = background
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        grid.isUserInteractionEnabled = true
        addBackground()
        addGrid()
        setupGrid()
    }
    
    func addBackground() {
        background.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(background)
    }
    
    func addGrid() {
        grid.position = center
        grid.delegate = self
        self.addChild(grid)
    }
    
    func setupGrid() {
        
        grid.setData(levelData)
    }
    
    func addRestart() {
        restartButton.position = CGPoint(x: frame.maxX - 32, y: frame.maxY - edgeInsets.top - 30)
        self.addChild(restartButton)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {
          return
        }
        let touchLocation = touch.location(in: self)
        if let node = self.nodes(at: touchLocation).first {
            if node == restartButton {
                restart()
            }
        }
    }
    
    func restart() {
        grid.restoreLevel(levelData)
        grid.isUserInteractionEnabled = true
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func levelComplete() {
        grid.isUserInteractionEnabled = false
        levelUserResponseDelegate?.didFinishTheLevel()
    }
}

extension GameScene: GridDelegate {
    func gridBtnDidPress(_ grid: Grid, btn: Btn, pos: GridPos) {
        let behavior = BehaviorFactory.getBehaviour(btn.type, pos: pos)
        grid.performBehavior(behavior)
        grid.level.printLayout()
        if self.grid.level.isCompleted {
            levelComplete()
        }
    }
}
