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
    
    override func didMove(to view: SKView) {
        setGrid()
    }
    
    func setGrid() {
        let levelData = [
            [LNode(type: 1), LNode(type: 1), LNode(type: 1)],
            [LNode(type: 1), LNode(type: 1), LNode(type: 1)],
            [LNode(type: 1), LNode(type: 1), LNode(type: 1)]
        ]
        grid.setData(levelData)
        grid.reloadData()
        grid.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        grid.delegate = self
        self.addChild(grid)
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
    func gridBtnDidPress(_ grid: Grid, btn: Btn, pos: LevelPosition) {
        let behavior = BehaviorFactory.getBehaviour(btn.type, pos: pos)
        grid.performBehavior(behavior)
        grid.level.printLayout()
        if self.grid.level.isCompleted {
            levelComplete()
        }
    }
}
