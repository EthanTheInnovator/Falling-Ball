//
//  GameScene.swift
//  Falling Ball
//
//  Created by Ethan Humphrey on 2/12/20.
//  Copyright © 2020 Ethan Humphrey. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let gapInFloor: CGFloat = 80
    let distanceBetweenPlatforms: CGFloat = 100
    let platformSpeed: TimeInterval = 10
    
    var player: SKShapeNode!
    var motionManager: CMMotionManager!
    var lastPlatform: SKShapeNode?
    
    var scoreLabel: SKLabelNode!
    
    var score: Int = 0
    
    var gameVC: GameViewController!
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .systemBackground
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        physicsWorld.contactDelegate = self
        
        createPlayer()
        motionManager = CMMotionManager()
        initializeBorders()
        createScoreLabel()
    }
    
    func beginGame() {
        
        motionManager.startDeviceMotionUpdates()
        player.physicsBody?.affectedByGravity = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if let deviceGravityAcceleration = motionManager.deviceMotion?.gravity {
            let deviceGravityVector = CGVector(dx: deviceGravityAcceleration.x, dy: deviceGravityAcceleration.y)
            let normalizedDeviceGravityVector = deviceGravityVector.normalized()
            physicsWorld.gravity = normalizedDeviceGravityVector * physicsWorld.gravity.magnitude
            if physicsWorld.gravity.dy > 0 {
                physicsWorld.gravity.dy = -1*physicsWorld.gravity.dy
            }
        }
        let initialSpawnPoint = (-view!.frame.height/2 - 100)
        if let lastPlatformCurrentY = lastPlatform?.position.y {
            let displacementOfLastPlatform = lastPlatformCurrentY - initialSpawnPoint
            if displacementOfLastPlatform >= distanceBetweenPlatforms {
                createPlatforms()
            }
        }
        else {
            createPlatforms()
        }
    }
    
    func createPlatforms() {
        let gapStartX = CGFloat.random(in: -view!.frame.width/2 ... (view!.frame.width/2) - gapInFloor)
        let gapEndX = gapStartX + gapInFloor
        if gapStartX > -view!.frame.width/2 + 10 {
            createPlatform(from: -view!.frame.width/2 - 20, to: gapStartX)
        }
        if gapEndX < view!.frame.width/2 - 10 {
            createPlatform(from: gapEndX, to: view!.frame.width/2 + 20)
        }
        createGap(from: gapStartX, to: gapEndX)
    }
    
    func createGap(from startX: CGFloat, to endX: CGFloat) {
        let platform = SKShapeNode(rect: CGRect(x: 0, y: 0, width: endX - startX, height: 30))
        platform.fillColor = .clear
        platform.lineWidth = 0
        platform.physicsBody = SKPhysicsBody(rectangleOf: platform.frame.size)
        platform.physicsBody?.categoryBitMask = CollisionCategory.goal
        platform.physicsBody?.collisionBitMask = CollisionCategory.none
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.linearDamping = 0
        platform.physicsBody?.mass = 10000
        platform.position = CGPoint(x: startX, y: -view!.frame.height/2 - 100)
        
        let moveAction = SKAction.move(by: CGVector(dx: 0, dy: view!.frame.height + 200), duration: platformSpeed)
        let destroyAction = SKAction.removeFromParent()
        let actions = SKAction.sequence([moveAction, destroyAction])
        lastPlatform = platform
        addChild(platform)
        platform.run(actions)
    }
    
    func createPlatform(from startX: CGFloat, to endX: CGFloat) {
        let platform = SKShapeNode(rect: CGRect(x: 0, y: 0, width: endX - startX, height: 30))
        platform.fillColor = .systemBlue
        platform.lineWidth = 0
        platform.physicsBody = SKPhysicsBody(edgeChainFrom: platform.path!)
        platform.physicsBody?.categoryBitMask = CollisionCategory.platform
        platform.physicsBody?.collisionBitMask = CollisionCategory.ball
        platform.physicsBody?.affectedByGravity = false
        platform.physicsBody?.isDynamic = false
        platform.physicsBody?.linearDamping = 0
        platform.physicsBody?.mass = 10000
        platform.position = CGPoint(x: startX, y: -view!.frame.height/2 - 100)
        
        let moveAction = SKAction.move(by: CGVector(dx: 0, dy: view!.frame.height + 200), duration: platformSpeed)
        let destroyAction = SKAction.removeFromParent()
        let actions = SKAction.sequence([moveAction, destroyAction])
        lastPlatform = platform
        addChild(platform)
        platform.run(actions)
    }
    
    func initializeBorders() {
        let leftBorderBody = SKPhysicsBody(edgeFrom: CGPoint(x: -view!.frame.width/2, y: view!.frame.height/2), to: CGPoint(x: -view!.frame.width/2, y: -view!.frame.height/2))
        leftBorderBody.categoryBitMask = CollisionCategory.sideWall
        let leftBorder = SKNode()
        leftBorder.physicsBody = leftBorderBody
        addChild(leftBorder)
        
        let rightBorderBody = SKPhysicsBody(edgeFrom: CGPoint(x: view!.frame.width/2, y: view!.frame.height/2), to: CGPoint(x: view!.frame.width/2, y: -view!.frame.height/2))
        rightBorderBody.categoryBitMask = CollisionCategory.sideWall
        let rightBorder = SKNode()
        rightBorder.physicsBody = rightBorderBody
        addChild(rightBorder)
        
        let bottomBorderBody = SKPhysicsBody(edgeFrom: CGPoint(x: -view!.frame.width/2, y: -view!.frame.height/2), to: CGPoint(x: view!.frame.width/2, y: -view!.frame.height/2))
        bottomBorderBody.categoryBitMask = CollisionCategory.bottomWall
        let bottomBorder = SKNode()
        bottomBorder.physicsBody = bottomBorderBody
        addChild(bottomBorder)
        
        let topBorderBody = SKPhysicsBody(edgeFrom: CGPoint(x: -view!.frame.width/2, y: view!.frame.height/2), to: CGPoint(x: view!.frame.width/2, y: view!.frame.height/2))
        topBorderBody.categoryBitMask = CollisionCategory.topWall
        let topBorder = SKNode()
        topBorder.physicsBody = topBorderBody
        addChild(topBorder)
    }
    
    func createPlayer() {
        player = SKShapeNode(circleOfRadius: 20)
        player.fillColor = .systemPurple
        player.position = CGPoint(x: 0, y: 0)
        player.lineWidth = 0
        player.zPosition = 9
        player.physicsBody = SKPhysicsBody(circleOfRadius: 20)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.categoryBitMask = CollisionCategory.ball
        player.physicsBody?.contactTestBitMask = CollisionCategory.all
        player.physicsBody?.collisionBitMask = CollisionCategory.bottomWall | CollisionCategory.sideWall | CollisionCategory.topWall | CollisionCategory.platform
        addChild(player)
    }
    
    func createScoreLabel() {
        scoreLabel = SKLabelNode(attributedText: getLabelFormattedText("Score: \(score)"))
        scoreLabel.fontColor = .label
        scoreLabel.position = CGPoint(x: -self.size.width/2 + 30, y: self.size.height/2 - 70)
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.zPosition = 10
        addChild(scoreLabel)
    }
    
    func updateScoreLabel() {
        scoreLabel.attributedText = getLabelFormattedText("Score: \(score)")
        if score >= Achievement.beginnerAchievement.currentProgress {
            Achievement.beginnerAchievement.currentProgress = score
            if score >= Achievement.beginnerAchievement.goalThreshold {
                Achievement.earnAchievement(.beginnerAchievement)
            }
        }
        if score >= Achievement.trueGamerAchievement.currentProgress {
            Achievement.trueGamerAchievement.currentProgress = score
            if score >= Achievement.trueGamerAchievement.goalThreshold {
                Achievement.earnAchievement(.trueGamerAchievement)
            }
        }
    }
    
    func getLabelFormattedText(_ originalString: String) -> NSAttributedString {
        let attrString = NSMutableAttributedString(string: originalString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: originalString.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.label, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 30)], range: range)
        return attrString
    }
    
    var isTouchingGoal = false
    var isTouchingBottom = false
    
    func didBegin(_ contact: SKPhysicsContact) {
        //Sort Collision
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        switch firstBody.categoryBitMask {
        case CollisionCategory.ball:
            switch secondBody.categoryBitMask {
            case CollisionCategory.goal:
                if !isTouchingGoal {
                    score += 1
                    isTouchingGoal = true
                    updateScoreLabel()
                }
            case CollisionCategory.bottomWall:
                if !isTouchingGoal && !isTouchingBottom {
                    score += 5
                    isTouchingBottom = true
                    updateScoreLabel()
                }
            case CollisionCategory.topWall:
                gameOver()
            default:
                break
            }
        default:
            break
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        //Sort Collision
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        switch firstBody.categoryBitMask {
        case CollisionCategory.ball:
            switch secondBody.categoryBitMask {
            case CollisionCategory.goal:
                isTouchingGoal = false
            case CollisionCategory.bottomWall:
                isTouchingBottom = false
            default:
                break
            }
        default:
            break
        }
    }
    
    func gameOver() {
        for child in children {
            child.isPaused = true
        }
        player.physicsBody?.isDynamic = false
        let gameOverLabel = SKLabelNode(attributedText: getLabelFormattedText("Game Over!"))
        gameOverLabel.fontColor = .label
        gameOverLabel.position = CGPoint(x: 0, y: 20)
        gameOverLabel.horizontalAlignmentMode = .center
        gameOverLabel.zPosition = 10
        addChild(gameOverLabel)
        
        let exitLabel = SKLabelNode(attributedText: getLabelFormattedText("Tap to Exit"))
        exitLabel.fontColor = .label
        exitLabel.position = CGPoint(x: 0, y: -20)
        exitLabel.horizontalAlignmentMode = .center
        exitLabel.zPosition = 10
        addChild(exitLabel)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if player.physicsBody?.isDynamic == false {
            gameVC.endGame()
        }
    }
}
