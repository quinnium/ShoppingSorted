//
//  ShoppingGroup.swift
//  ShoppingSorted
//
//  Created by Quinn on 28/09/2023.
//

import Foundation

// Struct used by ShoppingListView to group ShoppingItems in ShoppingGroups.
// Struct is not persisted, only used at run-time
struct ShoppingGroup: Identifiable, Hashable {
    let id = UUID()
    let commonName: String
    let commonUnit: String
    let totalQuantity: Double
    let shoppingItems: [ShoppingItem]
    
    init?(items: [ShoppingItem]) {
        guard items.count > 0 else { return nil }
        let commonName = items.first!.name
        let commonUnit = items.first!.unit
        guard items.allSatisfy({ $0.name == commonName }),
              items.allSatisfy({ $0.unit == commonUnit }) else { return nil }
        self.commonName = commonName
        self.commonUnit = commonUnit
        self.totalQuantity = items.reduce(0, { $0 + $1.quantity})
        self.shoppingItems = items
    }
}
