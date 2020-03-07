//
//  Achievement.swift
//  Falling Ball
//
//  Created by Ethan Humphrey on 3/5/20.
//  Copyright © 2020 Ethan Humphrey. All rights reserved.
//

/*
 The rubric didn't specifically ask for a comment but I figured I'd add one in just in case.
 I'll ACTUALLY keep this short.
 Basically I save each achievement's progress (as an int) to the UserDefaults dictionary on the device (along with whether or not it's been earned).
 Each achievement also has a "threshold" to meet so the progress can be shown.
 Setting the progress is self explanitory for each achievement (i.e. for the number of games the number is increased after a game is ended).
 Each achievement is a static variable so I can access them all everywhere.
 A notification pops up when you get an achievement.
 That's basically it. Nothing too fancy but setting up the data model took a lot of thinking to make it efficient.
 Have fun!
 
*/

import Foundation
import CoreGraphics
import UserNotifications

class Achievement: Identifiable {
    let id = UUID()
    
    var name: String
    var description: String
    var imageName: String
    var goalThreshold: Int
    
    @UserDefault("", defaultValue: 0)
    var currentProgress: Int
    
    @UserDefault("", defaultValue: false)
    var hasBeenEarned: Bool
    
    var progress: CGFloat {
        return CGFloat(self.currentProgress) / CGFloat(self.goalThreshold)
    }
    
    init(name: String, description: String, imageName: String, defaultsName: String, goalThreshold: Int) {
        self.name = name
        self.description = description
        self.imageName = imageName
        _currentProgress.key = defaultsName
        _hasBeenEarned.key = defaultsName + "Earned"
        self.goalThreshold = goalThreshold
    }
    
    struct DefaultsName {
        static let beginner = "beginnerAchievement"
        static let casual = "casualAchievement"
        static let king = "kingAchievement"
        static let addict = "addictAchievement"
        static let trueGamer = "gamerAchievement"
    }
    
    static var beginnerAchievement = Achievement(name: "Beginner", description: "Get a score of over 100", imageName: "baby", defaultsName: DefaultsName.beginner, goalThreshold: 100)
    static var casualAchievement = Achievement(name: "Casual", description: "Play 10 games of Stacker", imageName: "sofa", defaultsName: DefaultsName.casual, goalThreshold: 10)
    static var kingAchievement = Achievement(name: "King", description: "Get the high score in Stacker after 10 games", imageName: "crown", defaultsName: DefaultsName.king, goalThreshold: 1)
    static var addictAchievement = Achievement(name: "Addict", description: "Play 100 games of Stacker", imageName: "coffee", defaultsName: DefaultsName.addict, goalThreshold: 100)
    static var trueGamerAchievement = Achievement(name: "True Gamer", description: "Get a score of over 1000", imageName: "controller", defaultsName: DefaultsName.trueGamer, goalThreshold: 1000)
    
    static let allAchievements: [Achievement] = {
        return [
            Achievement.beginnerAchievement,
            Achievement.casualAchievement,
            Achievement.kingAchievement,
            Achievement.addictAchievement,
            Achievement.trueGamerAchievement
        ]
    }()
    
    static func earnAchievement(_ achievement: Achievement) {
        if !achievement.hasBeenEarned {
            let content = UNMutableNotificationContent()
            content.title = "Achievement Earned!"
            content.subtitle = "You've earned the \(achievement.name) achievement!"
            content.body = achievement.description
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { (error) in
                print(error)
            }
            achievement.hasBeenEarned = true
        }
    }
}
