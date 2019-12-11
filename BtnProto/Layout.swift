//
//  LevelLayoyt.swift
//  BtnProto
//
//  Created by Tim Isaev on 11.12.2019.
//  Copyright © 2019 Tim Isaev. All rights reserved.
//

import Foundation


enum BtnType: Int {
    case empty = 0
    case plain = 1
}

class LNode {
    let type: BtnType
    var isPressed: Bool
    
    init(type: BtnType, isPressed: Bool = false) {
        self.type = type
        self.isPressed = isPressed
    }
    
    init(type: Float) {
        let num = Int(type)
        let btnType = BtnType(rawValue: num) ?? .empty
        self.type = btnType
        self.isPressed = (type - Float(num)) > 0
    }
}

class Layout {
    
    var data: [[LNode]] = []
    
    var height: Int {
        return data.count
    }
    
    var width: Int {
        var maxRow = 0
        for row in data {
            maxRow = max(row.count, maxRow)
        }
        return maxRow
    }
}
