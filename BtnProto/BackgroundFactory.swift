//
//  BackgroundFactory.swift
//  BtnProto
//
//  Created by Tim Isaev on 07.01.2020.
//  Copyright © 2020 Tim Isaev. All rights reserved.
//

import SpriteKit


class BackgroundFactory {
    static func getBackground(size: CGSize) -> SKSpriteNode {
        let texture = SKTexture(size: size, startColor: SKColor(hex: 0x2C3A47), endColor: SKColor(hex: 0x596275))
        let sprite = SKSpriteNode(texture: texture)
        sprite.size = size
        sprite.color = .clear
        sprite.zPosition = -100
        return sprite
    }
}
