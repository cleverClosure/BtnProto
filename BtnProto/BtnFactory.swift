//
//  BtnFactory.swift
//  BtnProto
//
//  Created by Tim Isaev on 10.12.2019.
//  Copyright © 2019 Tim Isaev. All rights reserved.
//

import UIKit


class BtnFactory {
    static func createSimpleBtn(pos: CGPoint, levelPos: LevelPosition, isPressed: Bool = false) -> StdBtn {
        let btn = StdBtn(rect: CGRect(x: pos.x, y: pos.y, width: Constant.Dimension.btnSize, height: Constant.Dimension.btnSize), cornerRadius: 12)
        btn.isPressed = isPressed
        btn.setup(levelPos: levelPos)
        return btn
    }
    
    static func createBtn(type: BtnType, pos: CGPoint, levelPos: LevelPosition, isPressed: Bool = false) -> Btn {
        switch type {
        case .std:
            return createSimpleBtn(pos: pos, levelPos: levelPos, isPressed: isPressed)
        case .empty:
            return EmptyBtn()
        }
    }
}
