//
//  UserPreference.swift
//  NewsApp
//
//  Created by Ritesh Raj Singh Deopa on 06/02/21.
//

import UIKit

enum UserPreferenceKey: String {
    case search
    case bookmark
}

class UserPreference {

    class func value<T>(forKey key: UserPreferenceKey) -> T? {
        switch key {
        case .search:
            return UserDefaults.standard.array(forKey: key.rawValue) as? T
        case .bookmark:
            return UserDefaults.standard.array(forKey: key.rawValue) as? T
        }
    }

    class func set<T>(value: T?, forKey key: UserPreferenceKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }

    class func removeValue(key: UserPreferenceKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
}
