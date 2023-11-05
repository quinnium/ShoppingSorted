//
//  ShoppingItem.swift
//  ShoppingSorted
//
//  Created by Quinn on 27/08/2023.
//

import Foundation
import RealmSwift

class ShoppingItem: Object, ObjectKeyIdentifiable, PurchasableItem {
    
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String
    @Persisted var quantity: Double
    @Persisted var unit: String
    @Persisted var aisle: String
    @Persisted var forMeal: String?
    @Persisted var dateAdded: Date
    @Persisted var dateModified: Date
    @Persisted private(set) var purchased: Bool
    @Persisted private(set) var purchasedDate: Date?
    
    convenience init(name: String, quantity: Double, unit: String, aisle: String, forMeal: String? = nil) {
        self.init()
        self.name           = name
        self.quantity       = quantity
        self.unit           = unit
        self.aisle          = aisle
        self.forMeal        = forMeal
        self.dateAdded      = Date()
        self.dateModified   = Date()
        self.purchased      = false
        self.purchasedDate  = .none
    }
    
    func purchaseItem() {
        if let realm = self.realm {
            realm.beginWrite()
            self.purchased = true
            self.purchasedDate = Date()
            try? realm.commitWrite()
        } else {
            self.purchased = true
            self.purchasedDate = Date()
        }
        
    }
    
    func unPurchaseItem() {
        if let realm = self.realm {
            realm.beginWrite()
            self.purchased = false
            self.purchasedDate = .none
            try? realm.commitWrite()
        } else {
            self.purchased = false
            self.purchasedDate = .none
        }
    }
}
