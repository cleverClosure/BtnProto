//
//  VibroManager.swift
//  BtnProto
//
//  Created by Tim Isaev on 15.01.2020.
//  Copyright © 2020 Tim Isaev. All rights reserved.
//

import AudioToolbox

class VibroManager {
    
    static func peek() {
        AudioServicesPlaySystemSound(1519)
    }
    
    static func pop() {
        AudioServicesPlaySystemSound(1520)
    }
    
    static func error() {
        AudioServicesPlaySystemSound(1521)
    }
}
