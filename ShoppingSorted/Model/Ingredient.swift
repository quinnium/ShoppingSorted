//
//  Ingredient.swift
//  ShoppingSorted
//
//  Created by Quinn on 27/08/2023.
//

import Foundation
import RealmSwift

protocol PurchasableItem {
    var name: String { get set }
    var quantity: Double { get set }
    var unit: String { get set }
    var aisle: String { get set }
    var dateAdded: Date { get set }
    var dateModified: Date { get set }
}

class RMIngredient: Object, ObjectKeyIdentifiable, PurchasableItem, Codable {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var quantity: Double
    @Persisted var unit: String
    @Persisted var aisle: String
    @Persisted var dateAdded: Date
    @Persisted var dateModified: Date
    
    convenience init(name: String, quantity: Double, unit: String, aisle: String) {
        self.init()
        self.name           = name
        self.quantity       = quantity
        self.unit           = unit
        self.aisle          = aisle
        self.dateAdded      = Date()
        self.dateModified   = Date()
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case quantity
        case unit
        case aisle
        case dateAdded
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(quantity, forKey: .quantity)
        try container.encode(unit, forKey: .unit)
        try container.encode(aisle, forKey: .aisle)
        try container.encode(dateAdded, forKey: .dateAdded)
    }
}
