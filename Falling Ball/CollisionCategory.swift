//
//  CollisionCategory.swift
//  Falling Ball
//
//  Created by Ethan Humphrey on 2/19/20.
//  Copyright © 2020 Ethan Humphrey. All rights reserved.
//

import Foundation

struct CollisionCategory {
    static let none: UInt32 = 0
    static let all: UInt32 = UInt32.max
    static let ball: UInt32 = UInt32(1)
    static let sideWall: UInt32 = UInt32(2)
    static let topWall: UInt32 = UInt32(4)
    static let bottomWall: UInt32 = UInt32(8)
    static let goal: UInt32 = UInt32(16)
    static let platform: UInt32 = UInt32(32)
}
