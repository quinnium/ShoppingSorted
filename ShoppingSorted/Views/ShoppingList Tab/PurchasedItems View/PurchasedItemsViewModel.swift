//
//  PurchasedItemsViewModel.swift
//  ShoppingSorted
//
//  Created by Quinn on 02/10/2023.
//

import Foundation

class PurchasedItemsViewModel: ObservableObject {
    
    @Published var purchasedItems: [RMShoppingItem] = []
    private let databaseManager = DatabaseManager()
    
    init() {
        fetchItems()
    }
    
    func fetchItems() {
        var fetchedItems = databaseManager.getShoppingItems(purchased: true).sorted { $0.purchasedDate ?? Date() > $1.purchasedDate ?? Date() }
        if let filterToDate = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: Date()) {
            fetchedItems = fetchedItems.filter { $0.purchasedDate ?? Date() > filterToDate }
        }
        purchasedItems = fetchedItems
        
    }
    
    func unPurchase(item: RMShoppingItem) {
        item.unPurchaseItem()
        fetchItems()
    }
}
