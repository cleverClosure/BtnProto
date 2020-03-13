//
//  MainViewController.swift
//  BtnProto
//
//  Created by Tim Isaev on 07.01.2020.
//  Copyright © 2020 Tim Isaev. All rights reserved.
//

import UIKit


class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundPlayer.volume = 0.6
        backgroundPlayer.loop(name: "blueScorpion")
    }
    
    private func openGame() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "GameViewController")
        viewController.modalTransitionStyle = .crossDissolve
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: true, completion: nil)
    }

    @IBAction func actionPlay(_ sender: UIButton) {
        backgroundPlayer.pause()
        openGame()
    }
    
}
