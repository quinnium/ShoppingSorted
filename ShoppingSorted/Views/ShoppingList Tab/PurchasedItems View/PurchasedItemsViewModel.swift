//
//  PurchasedItemsViewModel.swift
//  ShoppingSorted
//
//  Created by Quinn on 02/10/2023.
//

import Foundation

class PurchasedItemsViewModel: ObservableObject {
    
    @Published var purchasedItems: [ShoppingItem] = []
    private let databaseManager = DatabaseManager()
    
    init() {
        fetchItems()
    }
    
    func fetchItems() {
        purchasedItems = databaseManager.getShoppingItems(purchased: true)
    }
    
    func unPurchase(item: ShoppingItem) {
        item.unPurchaseItem()
        fetchItems()
    }
}
