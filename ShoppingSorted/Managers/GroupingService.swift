//
//  GroupingService.swift
//  ShoppingSorted
//
//  Created by Quinn on 09/06/2023.
//

import Foundation

class GroupingService {
    
    // Function to return ingredients grouped by same name and unit
    static func getGroupedIngredients(from ingredients: [Ingredient]) -> [GroupedIngredients] {
        
        // Create tuple of unique 'names' and 'units'
        var nameAndUnitTupleArray: [(name: String, unit: String)] = []
        // Get list of unique item names
        let uniqueNames: Set<String> = Set(ingredients.compactMap { $0.name })
        for uniqueName in uniqueNames {
            // For each unique Name, get list of unique Units for that name
            let uniqueUnitsForname = Set(ingredients.filter { $0.name == uniqueName }.compactMap { $0.unit })
            // Add this unique Name & Unit tuple to nameAndUnitTupleArray
            for uniqueUnit in uniqueUnitsForname {
                nameAndUnitTupleArray.append((name: uniqueName, unit: uniqueUnit))
            }
        }
        
        // Generate a grouped item for each of these unique name&unit tuples
        var groupedIngredients: [GroupedIngredients] = []
        for uniqueTuple in nameAndUnitTupleArray {
            var group = GroupedIngredients(name: uniqueTuple.name, unit: uniqueTuple.unit)
            group.items = ingredients.filter { $0.name == group.name && $0.unit == group.unit }
            group.quantity = group.items.reduce(0) {$0 + $1.quantity}
            groupedIngredients.append(group)
        }
        // Sort into alphabetical order (by name, then by unit)
        groupedIngredients.sort { ($0.name, $0.unit) < ($1.name, $1.unit) }
        return groupedIngredients
    }
}
