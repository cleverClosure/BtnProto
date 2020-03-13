//
//  Grid.swift
//  BtnProto
//
//  Created by Tim Isaev on 11.12.2019.
//  Copyright © 2019 Tim Isaev. All rights reserved.
//

import SpriteKit

protocol GridDelegate: class {
    func gridBtnDidPress(_ grid: Grid, btn: Btn, pos: GridPos)
}

class Grid: SKNode {
    
    var level = Level(data: []) {
        didSet {
            printer.level = self.level
        }
    }
    
    var buttons: [[Btn]] = []
    lazy private var printer = LayoutPrinter(node: self, level: self.level)
    
    weak var delegate: GridDelegate?
    
    override var isUserInteractionEnabled: Bool {
        didSet {
            setUserInteraction(to: isUserInteractionEnabled)
        }
    }
    
    private func setUserInteraction(to val: Bool) {
        enumerateChildNodes(withName: "//btn") { (node, pointer) in
            node.isUserInteractionEnabled = val
        }
    }
    
    func setData(_ data: [[LNode]]) {
        printer.clear()
        clear()
        level.data = data
        draw()
    }
    
    func clear() {
        self.removeAllChildren()
    }
    
    private func draw() {
        printer.printLayout()
        buttons = printer.buttons
    }
    
    func restoreLevel(_ data: [[LNode]]) {
        level = Level(data: data)
        printer.restoreLevel()
    }
    
    func posIsInsideBoundaries(_ pos: GridPos) -> Bool {
        guard pos.row >= 0, pos.col >= 0 else {
            return false
        }
        guard pos.row < buttons.count else {
            return false
        }
        guard pos.col < buttons[pos.row].count else {
            return false
        }
        return true
    }
    
    func getButton(pos: GridPos) -> Btn? {
        guard posIsInsideBoundaries(pos) else {
            return nil
        }
        return buttons[pos.row][pos.col]
    }
    
    func updateLevelData(pos: GridPos, isPressed: Bool) {
        guard posIsInsideBoundaries(pos) else {
            return
        }
        level.data[pos.row][pos.col].isPressed = isPressed
        print("## mac \(pos.row), \(pos.col): \(isPressed), \(level.data[pos.row][pos.col].isPressed)")
    }
    
    func performBehavior(_ behavior: Behavior) {
        behavior.delegate = self
        behavior.perform()
    }
}


extension Grid: BehaviorDelegate {
    func toggleState(pos: [GridPos]) {
        var delay: Double = 0.05
        pos.forEach {
            if let btn = getButton(pos: $0) {
                btn.attemptToggle(delay: delay)
                delay += 0.06
                updateLevelData(pos: $0, isPressed: btn.isPressed)
            }
        }
    }
}


extension Grid: BtnDelegate {
    func btnDidPress(_ btn: Btn, levelPos: GridPos, isPressed: Bool) {
        updateLevelData(pos: levelPos, isPressed: isPressed)
        delegate?.gridBtnDidPress(self, btn: btn, pos: levelPos)
    }
}
