//
//  LayoutPrinter.swift
//  BtnProto
//
//  Created by Tim Isaev on 11.12.2019.
//  Copyright © 2019 Tim Isaev. All rights reserved.
//

import SpriteKit



class LayoutPrinter {
    
    weak var scene: SKScene!
    var level: Layout
    
    private var playRect: SKShapeNode!
    private let edge: CGFloat = 10
    private let btnGap: CGFloat = 6
    private let btnSize: CGFloat = 54
    private let bottomBtnHeight: CGFloat = 6
    
    init(scene: SKScene, level: Layout = Layout()) {
        self.scene = scene
        self.level = level
    }
    
    func print() {
        drawPlayRect()
        addButtons()
    }
    
    private func drawPlayRect() {
        let rect = getPlayRectFrame()
        let square = SKShapeNode(rect: rect, cornerRadius: 12)
        square.fillColor = UIColor(white: 1, alpha: 0.11)
        square.strokeColor = .clear
        square.lineWidth = 0
        playRect = square
        scene?.addChild(square)
    }
    
    private func addButtons() {
        let btnSize: CGFloat = 54
        let startX = playRect.frame.minX// + edge
        let startY = playRect.frame.maxY - (btnSize) - edge
        var x = startX - btnSize
        var y = startY + edge + btnSize
        for row in level.data {
            y = y - edge - btnSize
            x = startX - btnSize
            for item in row {
                x = x + edge + btnSize
                if item.type == .empty {
                    continue
                }
                let btn = BtnFactory.createSimpleBtn(pos: CGPoint(x: x, y: y), isPressed: item.isPressed)
                playRect.addChild(btn)
            }
        }
        
    }
    
    
    private func getPlayRectFrame() -> CGRect {
        let rawWidth = (CGFloat(level.width) * (btnSize + btnGap)) //- btnGap
        let width = rawWidth + edge * 2
        let rawHeight = (CGFloat(level.height) * (btnSize + btnGap)) - btnGap
        let height = rawHeight + (edge * 2) + bottomBtnHeight
        let x = (scene.frame.width / 2) - width / 2
        let y = (scene.frame.height / 2) - height / 2
        let rect = CGRect(x: x, y: y, width: width, height: height + bottomBtnHeight)
        return rect
    }
    
}
