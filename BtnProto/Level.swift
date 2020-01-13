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
    case std = 1
    case locked = 2
    case independent
}

struct LNode {
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

class Level {
    
    var data: [[LNode]] = []
    
    var height: Int {
        return data.count
    }
    
    var isCompleted: Bool {
        return isLevelCompleted()
    }
    
    var width: Int {
        var maxRow = 0
        for row in data {
            maxRow = max(row.count, maxRow)
        }
        return maxRow
    }
    
    private func isLevelCompleted() -> Bool {
        for row in data {
            for item in row {
                if !item.isPressed {
                    return false
                }
            }
        }
        return true
    }
    
    init(data: [[LNode]]) {
        self.data = data
    }
    
    func printLayout() {
        var str = "[\n"
        for row in data {
            str += "["
            for item in row {
                str += item.isPressed ? "+" : "-"
            }
            str += "]\n"
        }
        str += "]"
        print(str)
    }
}
