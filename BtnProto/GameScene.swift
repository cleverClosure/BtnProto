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
    
    lazy var printer = LayoutPrinter(scene: self)
    
    override func didMove(to view: SKView) {
        drawLevel()
    }
    
    func drawLevel() {
        let level = Layout()
        level.data = [
            [LNode(type: 1), LNode(type: 1), LNode(type: 1)],
            [LNode(type: 1), LNode(type: 1), LNode(type: 1)],
            [LNode(type: 1), LNode(type: 1), LNode(type: 1)]
        ]
        printer.level = level
        printer.print()
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
    }
}
