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
    var darkerColor: UIColor {
        return color.main.darker(by: 30)
    }
    
    fileprivate let cornerRadius = Constant.Dimension.btnMainRadius
    
    fileprivate let btnUnPressAnimationDiff: CGFloat = Constant.Dimension.btnBottomHeight / 1.4
    fileprivate let upABitAnimationDiff: CGFloat = (Constant.Dimension.btnBottomHeight / 2) * 0.4
    
    fileprivate lazy var down = SKAction.moveBy(x: 0, y: -self.btnUnPressAnimationDiff, duration: 0.1)
    fileprivate lazy var upABit = SKAction.moveBy(x: 0, y: self.upABitAnimationDiff, duration: 0.09)
    
    fileprivate lazy var downABit = SKAction.moveBy(x: 0, y: -self.upABitAnimationDiff, duration: 0.09)
    fileprivate lazy var up = SKAction.moveBy(x: 0, y: self.btnUnPressAnimationDiff, duration: 0.1)
    
    
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
        bottom.fillColor = darkerColor
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
        playSound()
        buttonPressVibration()
        delegate?.btnDidPress(self, levelPos: pos, isPressed: isPressed)
    }
    
    fileprivate func buttonPressVibration() {
        VibroManager.peek()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.14) {
            VibroManager.peek()
        }
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
        bgPart.run(SKAction.sequence([wait, down, upABit]))
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
    
    fileprivate func playSound() {
        fxPlayer.start(name: "tap")
    }
    
    /// This func is called by other buttons. Place any code you want to run after adjecent button calls this func.
    func attemptToggle(delay: Double = 0.05) {
        //doing nothing in Basic button
    }
    
    
}



class StdBtn: BasicBtn {
    
    var innerSquare: SKShapeNode!
    var edgeFrame: SKShapeNode!
    
    private let unHide = SKAction.fadeIn(withDuration: 0.1)
    private let hide = SKAction.fadeOut(withDuration: 0.1)
    
    fileprivate let innerRadius = Constant.Dimension.btnInnerRadius
    
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
        let square = SKShapeNode(rect: CGRect(x: frame.origin.x + (thickness / 2), y: frame.origin.y + (thickness / 2), width: size, height: size), cornerRadius: innerRadius)
        square.fillColor = color.main
        square.strokeColor = darkerColor
        square.lineWidth = 2
        edgeFrame = square
        edgeFrame.zPosition = 1
        bgPart.addChild(edgeFrame)
    }
    
    fileprivate func addInnerSquare() {
        let thickness: CGFloat = Constant.Dimension.btnEdgeThinckness + 2
        let size = frame.width - thickness
        let square = SKShapeNode(rect: CGRect(x: frame.origin.x + (thickness / 2), y: frame.origin.y + (thickness / 2), width: size, height: size), cornerRadius: innerRadius)
        square.fillColor = color.inner
        square.strokeColor = color.inner.withAlphaComponent(0.7)
        square.lineWidth = 1
        square.glowWidth = 7
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
        let upABitWait = SKAction.wait(forDuration: 0.1)
        bgPart.run(SKAction.sequence([wait, down, upABitWait, upABit]))
        innerSquare.run(SKAction.sequence([wait, unHide]))
        
//        edgeFrame.run(SKAction.sequence([wait, hide]))
    }
    
    override func animateUnPress(duration: Double = 0.1, delay: Double = 0) {
        let wait = SKAction.wait(forDuration: delay)
        up.duration = duration
        up.timingFunction = SpriteKitTimingFunctions.easeInQuad
        unHide.duration = duration
        innerSquare.run(SKAction.sequence([wait, hide]))
        let downABitWait = SKAction.wait(forDuration: 0.1)
        bgPart.run(SKAction.sequence([wait, downABit, downABitWait, up]))
        
//        edgeFrame.run(SKAction.sequence([wait, unHide]))
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
        return .purp
    }
    
    override func setup(levelPos: GridPos, delay: Double = 0) {
        super.setup(levelPos: levelPos, delay: delay)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
