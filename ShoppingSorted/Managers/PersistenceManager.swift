//
//  PersistenceManager.swift
//  ShoppingSorted
//
//  Created by Quinn on 01/01/2024.
//

import Foundation

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys  {
        static let hasMigratedFromCoreDataBool = "hasMigratedFromCoreDataBool"
    }
    
    static func save(value: Any, forKey key: String) {
        defaults.setValue(value, forKey: key)
    }
    
    static func getValue(forKey key: String) -> Any? {
        defaults.value(forKey: key)
    }
    
}
