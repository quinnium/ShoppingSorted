//
//  MealDetailShoppingListViewModel.swift
//  ShoppingSorted
//
//  Created by AQ on 06/04/2023.
//

import Foundation


class MealDetailViewModel: ObservableObject {
    
    private let dm = DataManager.shared
    @Published var meal: Meal?
    @Published var ingredients: [Ingredient]        = []
    @Published var mealName: String                 = ""
    @Published var isShowingAddMealCheck: Bool      = false
    @Published var isShowingDeleteMealCheck: Bool   = false
    @Published var dismissView: Bool                = false
    
    
    init(meal: Meal?) {
        self.meal       = meal
        self.mealName   = meal?.name ?? ""
        loadIngredients()
    }
    
    
    func loadIngredients() {
        ingredients = meal?.ingredients?.array as? [Ingredient] ?? []
        ingredients.sort { $0.dateCreated ?? Date() < $1.dateCreated ?? Date() }
    }
    
    
    func deleteMeal() {
        guard let mealToDelete  = meal else { return }
        self.meal               = nil
        dm.deleteMeal(meal: mealToDelete)
    }
    
    
    func saveName() {
        guard let meal = meal else { return }
        dm.updateMealName(meal: meal, newName: mealName)
    }
    
    
    func swipeToDeleteAction(at offsets: IndexSet) {
        guard let meal = meal else { return }
        var ingredientsToDelete: [Ingredient] = []
        for each in offsets {
            ingredientsToDelete.append(ingredients[each])
        }
        dm.removeIngredientsFromMeal(meal: meal, ingredients: ingredientsToDelete)
        ingredients.remove(atOffsets: offsets)
    }
    
    
    func addIngredientsToShoppingList(multiplier: Double) {
        // TODO: perhaps show alert if meal is blank?
        guard let meal          = meal else { return }
        guard let ingredients   = meal.ingredients?.array as? [Ingredient] else { return }
        dm.addIngredientsToShoppingLIst(ingredients: ingredients, multiplier: multiplier, mealTagForShoppingList: meal.name ?? "")
    }
}

