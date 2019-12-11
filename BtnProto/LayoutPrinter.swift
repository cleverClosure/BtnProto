//
//  LayoutPrinter.swift
//  BtnProto
//
//  Created by Tim Isaev on 11.12.2019.
//  Copyright © 2019 Tim Isaev. All rights reserved.
//

import SpriteKit



class LayoutPrinter {
    
    weak var parentNode: SKNode!
    var level: Level
    
    var buttons: [[Btn]] = []
    
    var playRect: SKShapeNode!
    private let edge: CGFloat = 10
    private let btnGap: CGFloat = 6
    private let btnSize: CGFloat = 54
    private let bottomBtnHeight: CGFloat = 6
    
    init(node: SKNode, level: Level = Level()) {
        self.parentNode = node
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
        parentNode?.addChild(square)
    }
    
    private func addButtons() {
        buttons = []
        let btnSize: CGFloat = 54
        let startX = playRect.frame.minX// + edge
        let startY = playRect.frame.maxY - (btnSize) - edge
        var x = startX - btnSize
        var y = startY + edge + btnSize
        for (rowIdx, row) in level.data.enumerated() {
            y = y - edge - btnSize
            x = startX - btnSize
            for (itemIdx, item) in row.enumerated() {
                x = x + edge + btnSize
                let btn = BtnFactory.createBtn(type: item.type, pos: CGPoint(x: x, y: y), levelPos: LevelPosition(rowIdx, itemIdx), isPressed: item.isPressed)
                if let delegate = parentNode as? BtnDelegate {
                    btn.delegate = delegate
                }
                if buttons.count <= rowIdx {
                    buttons.append([])
                }
                buttons[rowIdx].append(btn)
                if item.type == .empty {
                    continue
                }
                playRect.addChild(btn)
            }
        }
        
    }
    
    
    private func getPlayRectFrame() -> CGRect {
        let rawWidth = (CGFloat(level.width) * (btnSize + btnGap)) //- btnGap
        let width = rawWidth + edge * 2
        let rawHeight = (CGFloat(level.height) * (btnSize + btnGap)) - btnGap
        let height = rawHeight + (edge * 2) + bottomBtnHeight
        let x = (parentNode.frame.width / 2) - width / 2
        let y = (parentNode.frame.height / 2) - height / 2
        let rect = CGRect(x: x, y: y, width: width, height: height + bottomBtnHeight)
        return rect
    }
    
}
