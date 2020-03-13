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
    private let edge: CGFloat = Constant.Dimension.playRectEdge
    private let btnGap: CGFloat = Constant.Dimension.btnGap
    private let btnSize: CGFloat = Constant.Dimension.btnSize
    private let bottomBtnHeight: CGFloat = Constant.Dimension.btnBottomHeight
    
    init(node: SKNode, level: Level) {
        self.parentNode = node
        self.level = level
    }
    
    func printLayout() {
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
        parentNode.addChild(playRect)
    }
    
    private func addButtons() {
        buttons = []
        let startX = playRect.frame.minX + edge
        let startY = playRect.frame.maxY
        var x = startX
        var y = startY - edge + btnGap + bottomBtnHeight
        var currentAnimDelay: Double = 0.5
        for (rowIdx, row) in level.data.enumerated() {
            y = y - btnGap - btnSize - bottomBtnHeight
            x = startX - btnSize - btnGap
            for (itemIdx, item) in row.enumerated() {
                x = x + btnSize + btnGap
                let btn = BtnFactory.createBtn(type: item.type, pos: CGPoint(x: x, y: y), levelPos: GridPos(rowIdx, itemIdx), isPressed: item.isPressed, delay: currentAnimDelay)
                if let delegate = parentNode as? BtnDelegate {
                    btn.delegate = delegate
                }
                if buttons.count <= rowIdx {
                    buttons.append([])
                }
                buttons[rowIdx].append(btn)
                if item.type == .empty {
                    continue
                } else {
                    currentAnimDelay += 0.05
                }
                playRect.addChild(btn)
            }
        }
    }
    
    func restoreLevel() {
        level.printLayout()
        var currentDelay: Double = 0
        for (rowIdx, row) in buttons.enumerated() {
            for (itemIdx, btn) in row.enumerated() {
                if let button = btn as? BasicBtn {
                    currentDelay += 0.05
                    if level.data[rowIdx][itemIdx].isPressed {
                        button.press(delay: currentDelay)
                    } else {
                        button.unPress(delay: currentDelay)
                    }
                }
            }
        }
    }
    
    
    private func getPlayRectFrame() -> CGRect {
        
        let rawWidth = (CGFloat(level.width) * (btnSize + btnGap)) - btnGap
        let width = rawWidth + edge * 2
        print("## wd \(level.height)")
        let rawHeight = (CGFloat(level.height) * (btnSize + btnGap + bottomBtnHeight)) - btnGap
        let height = rawHeight + (edge * 2)
        let x = (parentNode.frame.width / 2) - width / 2
        let y = (parentNode.frame.height / 2) - height / 2
        let rect = CGRect(x: x, y: y, width: width, height: height)
        return rect
    }
    
    func clear() {
        parentNode.children.forEach {
            $0.removeFromParent()
        }
    }
    
}
