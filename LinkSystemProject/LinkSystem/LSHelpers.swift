//
//  LSHelpers.swift
//  LinkSystem
//
//  Created by Aamir  on 19/10/17.
//  Copyright © 2017 AamirAnwar. All rights reserved.
//

import Foundation

enum LSHelpers {
    
    static var totalGameCount:Int {
        return UserDefaults.standard.integer(forKey: kGameCountKey)
    }
    
    static var longestStreakCount:Int {
        return UserDefaults.standard.integer(forKey: kLinkStreakKey)
    }
    
    static func incrementGameCount() {
        var count:Int = UserDefaults.standard.integer(forKey: kGameCountKey)
        count += 1
        UserDefaults.standard.set(count, forKey: kGameCountKey)
    }
    
    static func updateLongestLinkStreak(withSteak newStreak:Int) {
        let currentStreakCount = UserDefaults.standard.integer(forKey: kLinkStreakKey)
        if currentStreakCount < newStreak {
            UserDefaults.standard.set(newStreak, forKey: kLinkStreakKey)
        }
    }
    
    
}

