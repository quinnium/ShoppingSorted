//
//  Aisle.swift
//  ShoppingSorted
//
//  Created by Quinn on 27/08/2023.
//

import Foundation
import RealmSwift

class RMAisle: Object {
    
    @Persisted var name: String
    @Persisted var order: Int
    
    convenience init(name: String, order: Int) {
        self.init()
        self.name = name
        self.order = order
    }
}
