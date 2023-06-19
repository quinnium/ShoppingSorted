//
//  AllMealsShoppingListViewModel.swift
//  ShoppingSorted
//
//  Created by AQ on 06/04/2023.
//

import CoreData

class AllMealsShoppingListViewModel: ObservableObject {
    
    private let dm = DataManager.shared

    @Published var meals: [Meal]                = []
    @Published var addMealName                  = ""
    @Published var isShowingAddMealOverlay      = false
    
    init() {
        loadMeals()
    }
    
    
    func loadMeals() {
        meals = dm.fetchAllMeals()
    }
    
    
    func deleteAllMeals() {
        dm.deleteAllMeals()
        loadMeals()
    }
    
    
    func addNewMeal() -> Meal {
        return dm.createNewMeal(mealName: addMealName)
    }
    
    
    func addRandomMeal() {
        dm.addRandomMeal()
        loadMeals()
    }
}
