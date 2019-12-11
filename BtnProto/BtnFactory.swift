//
//  BtnFactory.swift
//  BtnProto
//
//  Created by Tim Isaev on 10.12.2019.
//  Copyright © 2019 Tim Isaev. All rights reserved.
//

import UIKit


class BtnFactory {
    static func createSimpleBtn(pos: CGPoint, isPressed: Bool = false) -> BtnNode {
        let btn = BtnNode(rect: CGRect(x: pos.x, y: pos.y, width: 54, height: 54), cornerRadius: 12)
        btn.isPressed = isPressed
        btn.setup()
        return btn
    }
}
