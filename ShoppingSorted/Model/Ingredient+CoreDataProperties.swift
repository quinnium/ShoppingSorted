//
//  Ingredient+CoreDataProperties.swift
//  ShoppingSorted
//
//  Created by Quinn on 09/04/2023.
//
//

import Foundation
import CoreData


extension Ingredient {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ingredient> {
        return NSFetchRequest<Ingredient>(entityName: "Ingredient")
    }

    @NSManaged public var aisle: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var name: String?
    @NSManaged public var quantity: Double
    @NSManaged public var unit: String?
    @NSManaged public var purchased: Date?
    @NSManaged public var meal: Meal?
    @NSManaged public var mealTagForShoppingList: String?

}

extension Ingredient : Identifiable {
    var quantityString: String {
        let formatter                   = NumberFormatter()
        formatter.numberStyle           = .decimal
        formatter.maximumFractionDigits = 3
        return formatter.string(from: NSNumber(value: quantity)) ?? ""
    }
}
