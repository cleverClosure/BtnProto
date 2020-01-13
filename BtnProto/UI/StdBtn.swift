//
//  ButtonNode.swift
//  BtnProto
//
//  Created by Tim Isaev on 10.12.2019.
//  Copyright © 2019 Tim Isaev. All rights reserved.
//

import SpriteKit


struct GridPos {
    let row: Int
    let col: Int
    init(_ row: Int, _ col: Int) {
        self.row = row
        self.col = col
    }
}

protocol BtnDelegate {
    func btnDidPress(_ btn: Btn, levelPos: GridPos, isPressed: Bool)
}


protocol Btn: SKShapeNode {
    var pos: GridPos { get set }
    var isPressed: Bool { get set }
    var delegate: BtnDelegate? { get set }
    var type: BtnType { get }
    func attemptToggle(delay: Double)
}

extension Btn {
    func attemptToggle(delay: Double) {}
}

class EmptyBtn: SKShapeNode, Btn {
    var pos = GridPos(0, 0)
    var isPressed: Bool = true
    var delegate: BtnDelegate?
    var type: BtnType {
        return .empty
    }
}


class BasicBtn: SKShapeNode, Btn {
    
    var pos = GridPos(0, 0)
    var bgPart: SKShapeNode!
    var bottomPart: SKShapeNode!
    var isPressed: Bool = false
    var delegate: BtnDelegate?
    var color: ButtonColor {
        return .blue
    }
    
    let cornerRadius = Constant.Dimension.btnMainRadius
    
    private let down = SKAction.moveBy(x: 0, y: -Constant.Dimension.btnUnPressAnimationDiff, duration: 0.1)
    private let up = SKAction.moveBy(x: 0, y: Constant.Dimension.btnUnPressAnimationDiff, duration: 0.1)
    
    
    var type: BtnType {
        return .std
    }
    
    func setup(levelPos: GridPos, delay: Double = 0) {
        isUserInteractionEnabled = true
        fillColor = .clear
        strokeColor = .clear
        self.pos = levelPos
        addBg()
        addBottomPart()
        setInitialState(delay: delay)
    }
    
    func setInitialState(delay: Double = 0) {
        if isPressed {
            animatePress(duration: 0.1, delay: delay)
        } else {
            animatePress(duration: 0, delay: 0)
            animateUnPress(duration: 0.1, delay: delay)
        }
    }
    
    fileprivate func addBg() {
        let square = SKShapeNode(rect: self.frame, cornerRadius: cornerRadius)
        square.fillColor = color.main
        square.strokeColor = .clear
        square.lineWidth = 0
        bgPart = square
        bgPart.zPosition = 1
        addChild(square)
    }
    
    fileprivate func addBottomPart() {
        let width = frame.width
        let height: CGFloat = frame.height
        let bottom = SKShapeNode(rect: CGRect(x: frame.minX, y: frame.minY - Constant.Dimension.btnBottomHeight, width: width, height: height), cornerRadius: Constant.Dimension.btnBottomRadius)
        bottom.fillColor = color.inner
        bottom.lineWidth = 0
        bottom.zPosition = 0
        bottomPart = bottom
        addChild(bottom)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isPressed {
            press()
        } else {
            unPress()
        }
        delegate?.btnDidPress(self, levelPos: pos, isPressed: isPressed)
    }
    
    func press(delay: Double = 0) {
        guard !isPressed else {
            return
        }
        isPressed.toggle()
        animatePress(duration: 0.1, delay: delay)
    }
    
    func animatePress(duration: Double = 0.1, delay: Double = 0) {
        let wait = SKAction.wait(forDuration: delay)
        down.duration = duration
        bgPart.run(SKAction.sequence([wait, down]))
    }
    
    func unPress(delay: Double = 0) {
        guard isPressed else {
            return
        }
        isPressed.toggle()
        animateUnPress(duration: 0.1, delay: delay)
    }
    
    func animateUnPress(duration: Double = 0.1, delay: Double = 0) {
        let wait = SKAction.wait(forDuration: delay)
        up.duration = duration
        bgPart.run(SKAction.sequence([wait, up]))
    }
    
    /// This func is called by other buttons. Place any code you want to run after adjecent button calls this func.
    func attemptToggle(delay: Double = 0.05) {
        //doing nothing in Basic button
    }
    
}



class StdBtn: BasicBtn {
    
    var innerSquare: SKShapeNode!
    var edgeFrame: SKShapeNode!
    
    private let down = SKAction.moveBy(x: 0, y: -Constant.Dimension.btnUnPressAnimationDiff, duration: 0.1)
    private let unHide = SKAction.fadeIn(withDuration: 0.1)
    private let up = SKAction.moveBy(x: 0, y: Constant.Dimension.btnUnPressAnimationDiff, duration: 0.1)
    private let hide = SKAction.fadeOut(withDuration: 0.1)
    
    
    override func setup(levelPos: GridPos, delay: Double = 0) {
        isUserInteractionEnabled = true
        fillColor = .clear
        strokeColor = .clear
        self.pos = levelPos
        addBg()
        addEdgeFrame()
        addInnerSquare()
        addBottomPart()
        setInitialState(delay: delay)
    }
    
    fileprivate func addEdgeFrame() {
        let thickness: CGFloat = Constant.Dimension.btnEdgeThinckness
        let size = frame.width - thickness
        let square = SKShapeNode(rect: CGRect(x: frame.origin.x + (thickness / 2), y: frame.origin.y + (thickness / 2), width: size, height: size), cornerRadius: cornerRadius)
        square.fillColor = color.main
        square.strokeColor = color.inner
        square.lineWidth = 2
        edgeFrame = square
        edgeFrame.zPosition = 1
        bgPart.addChild(edgeFrame)
    }
    
    fileprivate func addInnerSquare() {
        let thickness: CGFloat = Constant.Dimension.btnEdgeThinckness
        let size = frame.width - thickness
        let square = SKShapeNode(rect: CGRect(x: frame.origin.x + (thickness / 2), y: frame.origin.y + (thickness / 2), width: size, height: size), cornerRadius: cornerRadius)
        square.fillColor = color.inner
        square.lineWidth = 0
        innerSquare = square
        innerSquare.zPosition = 1
        let hide = SKAction.fadeOut(withDuration: 0)
        innerSquare.run(hide)
        bgPart.addChild(innerSquare)
    }
    
    
    override func animatePress(duration: Double = 0.1, delay: Double = 0) {
        let wait = SKAction.wait(forDuration: delay)
        down.duration = duration
        unHide.duration = duration
        hide.duration = duration
        bgPart.run(SKAction.sequence([wait, down]))
        innerSquare.run(SKAction.sequence([wait, unHide]))
        edgeFrame.run(SKAction.sequence([wait, hide]))
    }
    
    override func animateUnPress(duration: Double = 0.1, delay: Double = 0) {
        let wait = SKAction.wait(forDuration: delay)
        up.duration = duration
        up.timingFunction = SpriteKitTimingFunctions.easeInQuad
        unHide.duration = duration
        innerSquare.run(SKAction.sequence([wait, hide]))
        bgPart.run(SKAction.sequence([wait, up]))
        edgeFrame.run(SKAction.sequence([wait, unHide]))
    }
    
    override func attemptToggle(delay: Double = 0.05) {
        if !isPressed {
            press(delay: delay)
        } else {
            unPress(delay: delay)
        }
    }
    
    
}


class OverlayBtn: StdBtn {
    
    var cropNode: SKCropNode!
    var overlay: SKSpriteNode {
        return SKSpriteNode()
    }
    
    var icon: SKSpriteNode? {
        return nil
    }
    
    
    override func setup(levelPos: GridPos, delay: Double = 0) {
        super.setup(levelPos: levelPos, delay: delay)
        makeAdditionalDrawings()
    }
    
    fileprivate func makeAdditionalDrawings() {
        addOverlay()
        addIcon()
    }
    
    fileprivate func addOverlay() {
        cropNode = SKCropNode()
        let mask = SKSpriteNode(imageNamed: "boundsMask")
        mask.position = CGPoint(x: innerSquare.frame.midX, y: innerSquare.frame.midY)
        mask.scale(to: frame.size)
        cropNode.maskNode = mask
        overlay.position = mask.position
        cropNode.addChild(overlay)
        cropNode.zPosition = 2
        bgPart.addChild(cropNode)
    }
    
    fileprivate func addIcon() {
        if let icon = icon {
            icon.zPosition = 3
            icon.position = CGPoint(x: innerSquare.frame.midX, y: innerSquare.frame.midY)
            bgPart.addChild(icon)
        }
    }
    
}

class LockedBtn: OverlayBtn {
    
    override var overlay: SKSpriteNode {
        let overlay = SKSpriteNode(imageNamed: "lighterStripes")
        overlay.position = CGPoint(x: innerSquare.frame.midX, y: innerSquare.frame.midY)
        overlay.scale(to: frame.size)
        return overlay
    }
    
    override var icon: SKSpriteNode? {
        let icon = SKSpriteNode(imageNamed: "lock")
        icon.setScale(Constant.Dimension.btnSize / 50)
        return icon
    }
    
    override var color: ButtonColor {
        return .black
    }
    
    override func setup(levelPos: GridPos, delay: Double = 0) {
        super.setup(levelPos: levelPos, delay: delay)
        isUserInteractionEnabled = false
    }
}


class IndependentBtn: StdBtn {
    override var color: ButtonColor {
        return .beige
    }
    
    override func attemptToggle(delay: Double = 0.05) {
        // do nothing
    }
}
