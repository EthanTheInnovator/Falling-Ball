//
//  GameViewController.swift
//  Falling Ball
//
//  Created by Ethan Humphrey on 2/12/20.
//  Copyright © 2020 Ethan Humphrey. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    @IBOutlet weak var spriteSceneView: SKView!
    var gameScene: GameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpGameScene()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        gameScene.beginGame()
    }
    
    func setUpGameScene() {
        gameScene = GameScene(size: spriteSceneView.bounds.size)
        gameScene.gameVC = self
        spriteSceneView.presentScene(gameScene)
        spriteSceneView.showsFPS = true
        spriteSceneView.showsNodeCount = true
        self.view.backgroundColor = .systemBackground
        spriteSceneView.backgroundColor = .systemBackground
    }
    
    func endGame() {
        if let welcomeNav = presentingViewController as? UINavigationController, let welcomeVC = welcomeNav.topViewController as? WelcomeViewController {
            let playerName = welcomeVC.nameTextField.text!
            welcomeVC.userSettings.highScores.append(PlayerScore(name: playerName, score: gameScene!.score))
            welcomeVC.nameTextField.text = ""
            welcomeVC.highScoresTableView.reloadData()
            dismiss(animated: true, completion: nil)
        }
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
}
