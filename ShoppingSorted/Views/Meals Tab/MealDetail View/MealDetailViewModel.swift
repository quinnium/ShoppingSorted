//
//  MealDetailViewModel.swift
//  ShoppingSorted
//
//  Created by Quinn on 28/08/2023.
//

import Foundation
import RealmSwift

class MealDetailViewModel: ObservableObject {
    
    // Custom Item for use in View's Ingredients List, so as not to diretly interact with live model objects
    struct IngredientsListItem: Identifiable {
        let id: ObjectId
        let name: String
        let quantity: Double
        let unit: String
    }
    
    let meal: Meal
    private var ingredients: [Ingredient] = [] {
        didSet {
            ingredientsList = ingredients.map { IngredientsListItem(id: $0.id,
                                                                    name: $0.name,
                                                                    quantity: $0.quantity,
                                                                    unit: $0.unit) }
        }
    }
    @Published var mealName: String                         = ""
    @Published var ingredientsList: [IngredientsListItem]   = []
    @Published var isAddingIngredient: Bool                 = false
    @Published var selectedIngredient: Ingredient?          = nil
    @Published var isShowingDeleteMealCheck: Bool           = false
    @Published var isShowingAddToListCheck: Bool            = false
    private let databaseManager                             = DatabaseManager()

    init(meal: Meal) {
        self.meal           = meal
        self.mealName       = meal.name
        fetchIngredients()
    }
    
    func saveMealName() {
        meal.updateName(name: mealName)
    }
    
    func fetchIngredients() {
        ingredients = Array(meal.ingredients)
    }
    
    func getIngredient(id: ObjectId) -> Ingredient? {
        ingredients.first { $0.id == id }
    }
    
    func deleteIngredient(at indexSet: IndexSet) {
        databaseManager.deleteIngredients(from: meal, at: indexSet)
        fetchIngredients()
    }
    
    func addIngredientsToShoppingList(multiplier: Double) {
        for ingredient in ingredients {
            databaseManager.addNewShoppingItem(name: ingredient.name,
                                               quantity: (ingredient.quantity * multiplier),
                                               unit: ingredient.unit,
                                               aisle: ingredient.aisle,
                                               forMeal: meal.name)
        }
    }
    
    func deleteMeal() {
        databaseManager.deleteMeal(meal: meal)
    }
}
