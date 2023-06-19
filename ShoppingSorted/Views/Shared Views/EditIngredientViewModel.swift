//
//  EditIngredientViewModel.swift
//  ShoppingSorted
//
//  Created by Quinn on 25/03/2023.
//

import CoreData

class EditIngredientViewModel: ObservableObject {

    private let dm = DataManager.shared
    
    let isAddingDirectlyToShoppingList: Bool
    let existingIngredient: Ingredient?
    let meal: Meal?

    @Published var itemName                             = ""
    @Published var itemQuantity: Double                 = 0
    @Published var itemUnit                             = ""
    @Published var itemAisle: String?                   = nil
    @Published var isEditingDefaults                    = false

    var unitList: [String]                              = []
    var aisleList: [String]                             = []
    var previousItemsDictionary: [String: Ingredient]   = [:]
    var searchResults: [String] {
        previousItemsDictionary.keys.sorted().filter { $0.range(of: itemName.trimmingCharacters(in: .whitespaces), options: .caseInsensitive) != nil }
    }
    var navigationTitleText: String {
        if isAddingDirectlyToShoppingList && existingIngredient == nil {
            return "Add to Shopping List"
        } else if existingIngredient == nil {
            return "Add Ingredient"
        } else {
            return "Edit Ingredient"
        }
    }
    var isAllFieldsCompleted: Bool {
        if !itemName.isEmpty &&
            itemQuantity > 0 &&
            unitList.contains(itemUnit) &&
            itemAisle != nil &&
            aisleList.contains(itemAisle!) {
            return true
        } else {
            return false
        }
    }
    
    init(isAddingDirectlyToShoppingList: Bool, existingIngredient: Ingredient?, meal: Meal?) {
        self.existingIngredient             = existingIngredient
        self.isAddingDirectlyToShoppingList = isAddingDirectlyToShoppingList
        self.meal                           = meal
        self.loadUnitsAndAisles()
        if existingIngredient != nil {
            configureForExistingIngredient(ingredient: existingIngredient!, includeQuantity: true)
        } else {
            resetForm()
        }
    }
    

    func loadUnitsAndAisles() {
        aisleList = dm.fetchAisles()
        unitList = dm.fetchUnits()
    }
    
    
    func configurePreviousItemsDictionary() {
        let allIngredients = dm.fetchAllPreviousIngredientsOldestFirst()
        for ingredient in allIngredients {
            previousItemsDictionary[ingredient.name ?? ""] = ingredient
        }
    }
    
    
    func configureForExistingIngredient(ingredient: Ingredient, includeQuantity: Bool) {
        itemName            = ingredient.name ?? ""
        if includeQuantity == true {
            itemQuantity    = ingredient.quantity
        }
        if unitList.contains(ingredient.unit ?? "") {
            itemUnit        = ingredient.unit ?? ""
        }
        if aisleList.contains(ingredient.aisle ?? "") {
            itemAisle       = ingredient.aisle ?? ""
        }
    }
    
    
    func addIngredientToShoppingList() {
        dm.addIngredientToShoppingList(name: itemName.trimmingCharacters(in: .whitespaces),
                                       aisle: itemAisle ?? "",
                                       quantity: itemQuantity,
                                       unit: itemUnit)
        configurePreviousItemsDictionary()
    }
    
        
    func addIngredientToMeal() {
        // TODO: show an error if 'meal' is nil?
        guard let meal      = meal else { return }
        dm.addIngredientToMeal(meal: meal,
                               name: itemName.trimmingCharacters(in: .whitespaces),
                               aisle: itemAisle ?? "",
                               quantity: itemQuantity,
                               unit: itemUnit)
    }
    
    
    func updateExistingIngredient() {
        guard let existingIngredient    = existingIngredient else { return }
        dm.updateExistingIngredient(existingIngredient: existingIngredient,
                                          name: itemName.trimmingCharacters(in: .whitespaces),
                                          aisle: itemAisle ?? "",
                                          quantity: itemQuantity,
                                          unit: itemUnit)
    }
    
    
    func resetForm() {
        itemName        = ""
        itemQuantity    = 0
        itemUnit        = unitList.first ?? ""
        itemAisle       = nil
    }
}
