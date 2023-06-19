//
//  PurchasedItemsViewModel.swift
//  ShoppingSorted
//
//  Created by Quinn on 24/03/2023.
//

import CoreData

class PurchasedItemsViewModel: ObservableObject {
    
    private let dm = DataManager.shared
    
    @Published var itemsPurchased: [GroupedIngredients] = []
    
    init() {
        fetchAllItems()
    }
    
    
    func fetchAllItems() {
        let items = dm.fetchPreviouslyPurchasedShoppingListItems()
        itemsPurchased = GroupingService.getGroupedIngredients(from: items).sorted { $0.items[0].purchased ?? Date() > $1.items[0].purchased ?? Date() }
        
    }
    
    
    func undoPurchase(groupItem: GroupedIngredients) {
        for item in groupItem.items {
            dm.markItemAsUnpurchased(item: item)
        }
        
        fetchAllItems()
    }
}
   
