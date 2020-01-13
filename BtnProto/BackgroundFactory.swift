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
        let texture = SKTexture(size: size, startColor: SKColor.brown, endColor: SKColor.blue)
        let sprite = SKSpriteNode()
        sprite.size = size
        sprite.color = .clear
//        sprite.texture = texture
        sprite.zPosition = -100
        return sprite
    }
}
