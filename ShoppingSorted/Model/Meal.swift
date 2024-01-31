//
//  Meal.swift
//  ShoppingSorted
//
//  Created by Quinn on 27/08/2023.
//

import Foundation
import RealmSwift

class RMMeal: Object, ObjectKeyIdentifiable, Codable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var ingredients: List<RMIngredient>
    @Persisted var dateCreated: Date
    
    convenience init(name: String, ingredients: [RMIngredient], dateCreated: Date = Date()) {
        self.init()
        self.name           = name
        self.ingredients    = List<RMIngredient>()
        self.ingredients.append(objectsIn: ingredients)
        self.dateCreated    = dateCreated
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case ingredients
        case dateCreated
    }
    
    func encode(to encoder: Encoder) throws {
        let ingredientsAray = Array(self.ingredients)
        var container       = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(dateCreated, forKey: .dateCreated)
        try container.encode(ingredientsAray, forKey: .ingredients)
    }

    func updateName(name: String) {
        if let realm = self.realm {
            try? realm.write {
                self.name = name
            }
        } else {
            self.name = name
        }
    }
    

}
