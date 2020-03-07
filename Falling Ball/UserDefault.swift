//
//  UserDefault.swift
//  Falling Ball
//
//  Created by Ethan Humphrey on 2/19/20.
//  Copyright © 2020 Ethan Humphrey. All rights reserved.
//

import Foundation
import Combine

@propertyWrapper
struct UserDefault<T> {
    public var key: String
    let defaultValue: T

    init(_ key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}
