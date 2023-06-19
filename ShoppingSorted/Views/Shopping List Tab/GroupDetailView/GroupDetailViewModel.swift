//
//  GroupDetailViewModel.swift
//  ShoppingSorted
//
//  Created by Quinn on 16/06/2023.
//

import Foundation
import CoreData

class GroupDetailViewModel: ObservableObject {
    
    let groupedIngredients: GroupedIngredients
    @Published var ingredients: [Ingredient] = []
    @Published var selectedIngredient: Ingredient?
    private var dm = DataManager.shared
    private var itemsMarkedAsPurchased: [NSManagedObjectID] = []
    private var timer: Timer?
    
    init(groupedIngredients: GroupedIngredients) {
        self.groupedIngredients = groupedIngredients
        self.ingredients = groupedIngredients.items
    }
    
    func purchaseIngredient(ingredient: Ingredient, purchase: Bool?) {
        if purchase == false {
            itemsMarkedAsPurchased.removeAll { $0 == ingredient.objectID }
        }
        else {
            itemsMarkedAsPurchased.append(ingredient.objectID)
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            self.dm.markShoppingItemsAsPurchased(items: self.itemsMarkedAsPurchased)
            
//            DispatchQueue.main.async {
                for itemPurchased in self.itemsMarkedAsPurchased {
                    self.ingredients.removeAll { $0.objectID == itemPurchased }
                }
//            }
        }
    }
}
