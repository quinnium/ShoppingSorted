//
//  GroupedIngredients.swift
//  ShoppingSorted
//
//  Created by Quinn on 02/06/2023.
//

import Foundation

/*
 This struct object is for the purposes of handling 'grouped' ingredients for the Shopping List screen.
 It is not stored in Core Data / any persistent stroage, but simply created/used ad hoc at run time when needed
 */

struct GroupedIngredients: Hashable, Identifiable {
    
    var id = UUID()
    let name: String
    let unit: String
    var quantity: Double = 0
    var quantityString: String {
        let formatter                   = NumberFormatter()
        formatter.numberStyle           = .decimal
        formatter.maximumFractionDigits = 3
        return formatter.string(from: NSNumber(value: quantity)) ?? ""
    }
    var items: [Ingredient] = []
}
