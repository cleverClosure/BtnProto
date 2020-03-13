//
//  GameViewController.swift
//  BtnProto
//
//  Created by Tim Isaev on 10.12.2019.
//  Copyright © 2019 Tim Isaev. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import SAConfettiView


protocol LevelUserResponseDelegate {
    func didFinishTheLevel()
    func didQuitLevel()
}

class GameViewController: UIViewController {
    
    lazy var scene = GameScene(size:CGSize(width: view.frame.width, height: view.frame.height), levelData: GameData.LevelData.level1, background: BackgroundFactory.getBackground(size: view.frame.size))
    
    var confettiView: SAConfettiView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        scene.levelUserResponseDelegate = self
        skView.presentScene(scene)
        addConfettiEmitter()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scene.edgeInsets = view.safeAreaInsets
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func addConfettiEmitter() {
        confettiView = SAConfettiView(frame: self.view.bounds)
        
        // Set colors (default colors are red, green and blue)
        confettiView?.colors = [UIColor(red:0.95, green:0.40, blue:0.27, alpha:1.0),
                               UIColor(red:1.00, green:0.78, blue:0.36, alpha:1.0),
                               UIColor(red:0.48, green:0.78, blue:0.64, alpha:1.0),
                               UIColor(red:0.30, green:0.76, blue:0.85, alpha:1.0),
                               UIColor(red:0.58, green:0.39, blue:0.55, alpha:1.0)]
        
        // Set intensity (from 0 - 1, default intensity is 0.5)
        confettiView?.intensity = 1
        
        // Set type
        confettiView?.type = .Confetti
        
        // For custom image
        // confettiView.type = .Image(UIImage(named: "diamond")!)
        
        // Add subview
        if let confettiView = confettiView {
            view.addSubview(confettiView)
        }
        
    }
}

extension GameViewController: LevelUserResponseDelegate {
    func didQuitLevel() {
        backgroundPlayer.unPause()
    }
    
    func didFinishTheLevel() {
        confettiView?.startConfetti()
        backgroundPlayer.unPause()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.confettiView?.stopConfetti()
        }
    }
}
