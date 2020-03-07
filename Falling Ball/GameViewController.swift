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
            calculateAchievements(highScores: welcomeVC.userSettings.highScores)
            
            let playerName = welcomeVC.nameTextField.text!
            welcomeVC.userSettings.highScores.append(PlayerScore(name: playerName, score: gameScene!.score))
            welcomeVC.nameTextField.text = ""
            welcomeVC.highScoresTableView.reloadData()
            dismiss(animated: true, completion: nil)
        }
    }
    
    func calculateAchievements(highScores: [PlayerScore]) {
        if highScores.count >= 10 && highScores.first!.score < gameScene!.score {
                Achievement.kingAchievement.currentProgress = 1
                Achievement.earnAchievement(.kingAchievement)
        }
        Achievement.casualAchievement.currentProgress += 1
        Achievement.addictAchievement.currentProgress += 1
        if Achievement.casualAchievement.currentProgress >= Achievement.casualAchievement.goalThreshold {
            Achievement.earnAchievement(.casualAchievement)
        }
        if Achievement.addictAchievement.currentProgress >= Achievement.addictAchievement.goalThreshold {
            Achievement.earnAchievement(.addictAchievement)
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
