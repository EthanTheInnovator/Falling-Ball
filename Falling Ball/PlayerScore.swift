//
//  PlayerScore.swift
//  Falling Ball
//
//  Created by Ethan Humphrey on 2/19/20.
//  Copyright © 2020 Ethan Humphrey. All rights reserved.
//

import Foundation

struct PlayerScore: Identifiable {
    var id: UUID = UUID()
    var name: String
    var score: Int
    
    func convertToDict() -> [String: Any] {
        var dict = [String: Any]()
        dict["name"] = self.name
        dict["score"] = self.score
        dict["id"] = self.id.uuidString
        return dict
    }
    
    init(from dict: [String: Any]) {
        if let dictName = dict["name"] as? String {
            self.name = dictName
        }
        else {
            self.name = ""
        }
        if let dictScore = dict["score"] as? Int {
            self.score = dictScore
        }
        else {
            self.score = 0
        }
        if let dictID = dict["id"] as? String {
            self.id = UUID(uuidString: dictID)!
        }
    }
    
    init(name: String, score: Int) {
        self.name = name
        self.score = score
    }
    
    static func convertToArray(from dictArray: [[String: Any]]) -> [PlayerScore] {
        return dictArray.map { (dict) -> PlayerScore in
            return PlayerScore(from: dict)
        }
    }
    
    static func convertToDict(from scoreArray: [PlayerScore]) -> [[String: Any]] {
        return scoreArray.map { (playerScore) -> [String: Any] in
            return playerScore.convertToDict()
        }
    }
    
    static func == (first: PlayerScore, second: PlayerScore) -> Bool {
        return (first.name == second.name) && (first.score == second.score)
    }
    
}
