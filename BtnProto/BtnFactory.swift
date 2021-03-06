//
//  BtnFactory.swift
//  BtnProto
//
//  Created by Tim Isaev on 10.12.2019.
//  Copyright © 2019 Tim Isaev. All rights reserved.
//

import UIKit


class BtnFactory {
    static private func createSimpleBtn(pos: CGPoint, levelPos: GridPos, isPressed: Bool = false, delay: Double = 0) -> StdBtn {
        let btn = StdBtn(rect: CGRect(x: pos.x, y: pos.y, width: Constant.Dimension.btnSize, height: Constant.Dimension.btnSize), cornerRadius: 12)
        btn.isPressed = isPressed
        btn.setup(levelPos: levelPos, delay: delay)
        return btn
    }
    
    static private func createIndependentBtn(pos: CGPoint, levelPos: GridPos, isPressed: Bool = false, delay: Double = 0) -> StdBtn {
        let btn = IndependentBtn(rect: CGRect(x: pos.x, y: pos.y, width: Constant.Dimension.btnSize, height: Constant.Dimension.btnSize), cornerRadius: 12)
        btn.isPressed = isPressed
        btn.setup(levelPos: levelPos, delay: delay)
        return btn
    }
    
    static private func createLockedBtn(pos: CGPoint, levelPos: GridPos, isPressed: Bool = false, delay: Double = 0) -> StdBtn {
        let btn = LockedBtn(rect: CGRect(x: pos.x, y: pos.y, width: Constant.Dimension.btnSize, height: Constant.Dimension.btnSize), cornerRadius: 12)
        btn.isPressed = isPressed
        btn.setup(levelPos: levelPos, delay: delay)
        return btn
    }
    
    static func createBtn(type: BtnType, pos: CGPoint, levelPos: GridPos, isPressed: Bool = false, delay: Double = 0) -> Btn {
        var btn: Btn
        switch type {
        case .std:
            btn = createSimpleBtn(pos: pos, levelPos: levelPos, isPressed: isPressed, delay: delay)
        case .empty:
            btn = EmptyBtn()
        case .locked:
            btn = createLockedBtn(pos: pos, levelPos: levelPos, isPressed: isPressed, delay: delay)
        case .independent:
            btn = createIndependentBtn(pos: pos, levelPos: levelPos, isPressed: isPressed, delay: delay)
        }
        btn.name = "btn"
        return btn
    }
}
