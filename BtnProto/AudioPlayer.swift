//
//  AudioPlayer.swift
//  BtnProto
//
//  Created by Tim Isaev on 14.01.2020.
//  Copyright © 2020 Tim Isaev. All rights reserved.
//


import AVFoundation

let backgroundPlayer = AudioPlayer()
let fxPlayer = AudioPlayer()

class AudioPlayer {
    
    private var player = AVAudioPlayer()
    
    private let fadeDuration: TimeInterval = 0.5
    var volume: Float = 1
    
    func loop(name: String) {
        start(name: name)
        player.numberOfLoops = -1
        player.setVolume(0, fadeDuration: 0)
        player.setVolume(volume, fadeDuration: fadeDuration)
    }
    
    func pause() {
        player.setVolume(0, fadeDuration: fadeDuration)
        DispatchQueue.main.asyncAfter(deadline: .now() + fadeDuration + 0.1) {
            self.player.pause()
        }
    }
    
    func unPause() {
        player.play()
        player.setVolume(volume, fadeDuration: fadeDuration)
    }
    
    func start(name: String) {
        let AssortedMusics = URL(fileURLWithPath: Bundle.main.path(forResource: name, ofType: "mp3")!)
        player = try! AVAudioPlayer(contentsOf: AssortedMusics)
        player.numberOfLoops = 0
        player.prepareToPlay()
        player.play()
    }
}

