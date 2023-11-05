//
//  Meal.swift
//  ShoppingSorted
//
//  Created by Quinn on 27/08/2023.
//

import Foundation
import RealmSwift

class Meal: Object, ObjectKeyIdentifiable, Codable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var ingredients: List<Ingredient>
    @Persisted var dateCreated: Date
    
    convenience init(name: String, ingredients: [Ingredient], dateCreated: Date = Date()) {
        self.init()
        self.name           = name
        self.ingredients    = List<Ingredient>()
        self.ingredients.append(objectsIn: ingredients)
        self.dateCreated    = dateCreated
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case ingredients
        case dateCreated
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(dateCreated, forKey: .dateCreated)
        let ingredientsAray = Array(self.ingredients)
//        let ingredientsAray: [Ingredient] = []
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
