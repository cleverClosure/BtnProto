//
//  Grid.swift
//  BtnProto
//
//  Created by Tim Isaev on 11.12.2019.
//  Copyright © 2019 Tim Isaev. All rights reserved.
//

import SpriteKit

protocol GridDelegate: class {
    func gridBtnDidPress(_ grid: Grid, btn: Btn, pos: LevelPosition)
}

class Grid: SKNode {
    
    var level = Level()
    var buttons: [[Btn]] = []
    lazy private var printer = LayoutPrinter(node: self, level: self.level)
    
    weak var delegate: GridDelegate?
    
    func setData(_ data: [[LNode]]) {
        level.data = data
    }
    
    func reloadData() {
        draw()
    }
    
    private func draw() {
        printer.print()
        buttons = printer.buttons
    }
    
    func posIsInsideBoundaries(_ pos: LevelPosition) -> Bool {
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
    
    func getButton(pos: LevelPosition) -> Btn? {
        guard posIsInsideBoundaries(pos) else {
            return nil
        }
        return buttons[pos.row][pos.col]
    }
    
    func updateLevelData(pos: LevelPosition, isPressed: Bool) {
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
    func toggleState(pos: LevelPosition) {
        if let btn = getButton(pos: pos) {
            btn.attemptToggle()
            updateLevelData(pos: pos, isPressed: btn.isPressed)
        }
    }
}


extension Grid: BtnDelegate {
    func btnDidPress(_ btn: Btn, levelPos: LevelPosition, isPressed: Bool) {
        updateLevelData(pos: levelPos, isPressed: isPressed)
        delegate?.gridBtnDidPress(self, btn: btn, pos: levelPos)
    }
}
