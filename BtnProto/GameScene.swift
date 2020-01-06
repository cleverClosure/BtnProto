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
    
    var edgeInsets: UIEdgeInsets! {
        didSet {
            addRestart()
        }
    }
    
    let levelData = [
        [LNode(type: 1), LNode(type: 1), LNode(type: 1)],
        [LNode(type: 1), LNode(type: 2), LNode(type: 1)],
        [LNode(type: 1), LNode(type: 1), LNode(type: 1)],
    ]
    
    let restartButton = SKSpriteNode(imageNamed: "restart")
    
    override func didMove(to view: SKView) {
        addGrid()
        setupGrid()
    }
    
    func addGrid() {
        grid.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
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
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func levelComplete() {
        self.backgroundColor = .lightGray
        let ac = SKAction.colorize(with: UIColor.lightGray, colorBlendFactor: 1, duration: 2)
        self.run(ac)
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
