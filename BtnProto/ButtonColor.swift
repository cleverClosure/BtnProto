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
    case black
    
    var main: UIColor {
        switch self {
        case .blue:
            return UIColor(hex: 0x25CCF7)
        case .red:
            return UIColor(hex: 0xBF4850)
        case .black:
            return UIColor(hex: 0x2d3436)
        }
    }
    
    var inner: UIColor {
        switch self {
        case .blue:
            return UIColor(hex: 0x209FC0)
        case .red:
            return UIColor(hex: 0x982C33)
        case .black:
            return UIColor(hex: 0x1D2223)
        }
    }
}
