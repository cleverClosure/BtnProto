//
//  ButtonNode.swift
//  BtnProto
//
//  Created by Tim Isaev on 10.12.2019.
//  Copyright © 2019 Tim Isaev. All rights reserved.
//

import SpriteKit

enum Color {
    case blue
    
    var color: UIColor {
        switch self {
        case .blue:
            return UIColor(hex: 0x25CCF7)
        }
    }
    
    var innerColor: UIColor {
        switch self {
        case .blue:
            return UIColor(hex: 0x209FC0)
        }
    }
}

struct LevelPosition {
    let row: Int
    let col: Int
    init(_ row: Int, _ col: Int) {
        self.row = row
        self.col = col
    }
}

protocol BtnDelegate {
    func btnDidPress(_ btn: Btn, levelPos: LevelPosition, isPressed: Bool)
}


protocol Btn: SKShapeNode {
    var levelPos: LevelPosition { get set }
    var isPressed: Bool { get set }
    var delegate: BtnDelegate? { get set }
    var type: BtnType { get }
    func attemptToggle(delay: Double)
}

extension Btn {
    func attemptToggle(delay: Double) {}
}

class EmptyBtn: SKShapeNode, Btn {
    
    var levelPos = LevelPosition(0, 0)
    var isPressed: Bool = true
    var delegate: BtnDelegate?
    var type: BtnType {
        return .empty
    }
}



class StdBtn: SKShapeNode, Btn {

    var levelPos = LevelPosition(0, 0)
    var innerSquare: SKShapeNode!
    var bgPart: SKShapeNode!
    var bottomPart: SKShapeNode!
    var isPressed: Bool = false
    var delegate: BtnDelegate?
    
    let cornerRadius = Constant.Dimension.btnMainRadius
    
    private let down = SKAction.moveBy(x: 0, y: -Constant.Dimension.btnUnPressAnimationDiff, duration: 0.1)
    private let unHide = SKAction.fadeIn(withDuration: 0.1)
    private let up = SKAction.moveBy(x: 0, y: Constant.Dimension.btnUnPressAnimationDiff, duration: 0.1)
    private let hide = SKAction.fadeOut(withDuration: 0.1)
    
    
    var type: BtnType {
        return .std
    }
    
    func setup(levelPos: LevelPosition) {
        isUserInteractionEnabled = true
        fillColor = .clear
        strokeColor = .clear
        self.levelPos = levelPos
        addBg()
        addInnerSquare()
        addBottomPart()
        if isPressed {
            animatePress(duration: 0.1)
        }
    }
    
    private func setPressAnimations() {
        
    }
    
    func addBg() {
        let square = SKShapeNode(rect: self.frame, cornerRadius: cornerRadius)
        square.fillColor = Color.blue.color
        square.strokeColor = .clear
        square.lineWidth = 0
        bgPart = square
        bgPart.zPosition = 1
        addChild(square)
    }
    
    func addInnerSquare() {
        let thickness: CGFloat = Constant.Dimension.btnEdgeThinckness
        let size = frame.width - thickness
        let square = SKShapeNode(rect: CGRect(x: frame.origin.x + (thickness / 2), y: frame.origin.y + (thickness / 2), width: size, height: size), cornerRadius: cornerRadius)
        square.fillColor = Color.blue.innerColor
        square.lineWidth = 0
        innerSquare = square
        innerSquare.zPosition = 1
        let hide = SKAction.fadeOut(withDuration: 0)
        innerSquare.run(hide)
        bgPart.addChild(innerSquare)
        
    }
    
    func addBottomPart() {
        let width = frame.width
        let height: CGFloat = frame.height
        let bottom = SKShapeNode(rect: CGRect(x: frame.minX, y: frame.minY - Constant.Dimension.btnBottomHeight, width: width, height: height), cornerRadius: Constant.Dimension.btnBottomRadius)
        bottom.fillColor = Color.blue.innerColor
        bottom.lineWidth = 0
        bottom.zPosition = -1
        bottomPart = bottom
        addChild(bottom)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isPressed {
            press()
        } else {
            unPress()
        }
        isPressed.toggle()
        delegate?.btnDidPress(self, levelPos: levelPos, isPressed: isPressed)
    }
    
    private func press(delay: Double = 0) {
        guard !isPressed else {
            return
        }
        animatePress(duration: 0.1, delay: delay)
    }
    
    private func animatePress(duration: Double = 0.1, delay: Double = 0) {
        let wait = SKAction.wait(forDuration: delay)
        down.duration = duration
        unHide.duration = duration
        
        bgPart.run(SKAction.sequence([wait, down]))
        innerSquare.run(SKAction.sequence([wait, unHide]))
    }
    
    private func unPress(delay: Double = 0) {
        guard isPressed else {
            return
        }
        animateUnPress(duration: 0.1, delay: delay)
    }
    
    private func animateUnPress(duration: Double = 0.1, delay: Double = 0) {
        let wait = SKAction.wait(forDuration: delay)
        up.duration = duration
        hide.duration = duration
        innerSquare.run(SKAction.sequence([wait, hide]))
        bgPart.run(SKAction.sequence([wait, up]))
    }
    
    func attemptToggle(delay: Double = 0.05) {
        if !isPressed {
            press(delay: delay)
        } else {
            unPress(delay: delay)
        }
        isPressed.toggle()
    }
    
}

