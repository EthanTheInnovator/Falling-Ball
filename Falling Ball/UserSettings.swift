//
//  UserSettings.swift
//  Falling Ball
//
//  Created by Ethan Humphrey on 2/19/20.
//  Copyright © 2020 Ethan Humphrey. All rights reserved.
//

import SwiftUI
import Foundation
import Combine

final class UserSettings: ObservableObject {

    let objectWillChange = PassthroughSubject<Void, Never>()

    @UserDefault("highScores", defaultValue: [[String: Any]]())
    private var defaultsHighScores: [[String: Any]] {
        willSet {
            objectWillChange.send()
        }
    }
    
    var highScores: [PlayerScore] {
        get {
            return PlayerScore.convertToArray(from: defaultsHighScores).sorted(by: { (firstScore, secondScore) -> Bool in
                return firstScore.score > secondScore.score
            })
        }
        set {
            defaultsHighScores = PlayerScore.convertToDict(from: newValue)
            objectWillChange.send()
        }
    }
    
    
}
