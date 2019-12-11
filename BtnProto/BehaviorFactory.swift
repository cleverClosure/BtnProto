//
//  BehaviorFactory.swift
//  BtnProto
//
//  Created by Tim Isaev on 11.12.2019.
//  Copyright © 2019 Tim Isaev. All rights reserved.
//

import Foundation

protocol BehaviorDelegate {
    func toggleState(pos: LevelPosition)
}

class Behavior {
    var btnPos: LevelPosition
    var delegate: BehaviorDelegate?
    
    init(pos: LevelPosition) {
        self.btnPos = pos
    }
    func perform() {}
}

class StdBehavior: Behavior {
    
    override func perform() {
        let item1 = LevelPosition(btnPos.row + 1, btnPos.col)
        let item2 = LevelPosition(btnPos.row - 1, btnPos.col)
        let item3 = LevelPosition(btnPos.row, btnPos.col + 1)
        let item4 = LevelPosition(btnPos.row, btnPos.col - 1)
        [item1, item2, item3, item4].forEach {
            delegate?.toggleState(pos: $0)
        }
    }
}


class BehaviorFactory {
    
    static func getBehaviour(_ type: BtnType, pos: LevelPosition) -> Behavior {
        switch type {
        case .empty:
            return Behavior(pos: pos)
        case .std:
            return StdBehavior(pos: pos)
        }
    }
}
