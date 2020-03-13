//
//  ButtonColor.swift
//  BtnProto
//
//  Created by Tim Isaev on 05.01.2020.
//  Copyright © 2020 Tim Isaev. All rights reserved.
//

import UIKit

enum ButtonColor {
    case blue
    case red
    case purp
    case beige
    
    var main: UIColor {
        switch self {
        case .blue:
            return UIColor(hex: 0x18BAE4)
        case .red:
            return UIColor(hex: 0xBF4850)
        case .purp:
            return UIColor(hex: 0x342967)
        case .beige:
            return UIColor(hex: 0xFFFCED)
        }
    }
    
    var inner: UIColor {
        switch self {
        case .blue:
            return UIColor(hex: 0x6EDCF9)
        case .red:
            return UIColor(hex: 0x982C33)
        case .purp:
            return main.lighter(by: 30)//UIColor(hex: 0x1D2223)
        case .beige:
            return UIColor(hex: 0xCECAB7)
        }
    }
}
