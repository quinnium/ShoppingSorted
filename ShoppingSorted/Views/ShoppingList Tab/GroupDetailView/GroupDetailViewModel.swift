//
//  GroupDetailViewModel.swift
//  ShoppingSorted
//
//  Created by Quinn on 02/10/2023.
//

import Foundation

class GroupDetailViewModel: ObservableObject {
    private let group: ShoppingGroup
    @Published var shoppingItems: [RMShoppingItem] = []
    @Published var itemSelectedForEditing: RMShoppingItem?
    private var itemsQueuedForPurchase: [RMShoppingItem] = [] {
        didSet {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.purchaseItemsQueuedForPurchase()
            }
        }
    }
    private var timer: Timer?
    private let databaseManager = DatabaseManager()
    
    init(group: ShoppingGroup) {
        self.group = group
        fetchItems()
    }
    
    func fetchItems() {
        shoppingItems = group.shoppingItems.filter { $0.purchased == false}
    }
    
    func itemMarkedAsPurchased(item: RMShoppingItem) {
        itemsQueuedForPurchase.append(item)
    }
    
    func itemMarkedAsUnpurchased(item: RMShoppingItem) {
            itemsQueuedForPurchase.removeAll { $0.id == item.id }
    }
    
    private func purchaseItemsQueuedForPurchase() {
        for item in itemsQueuedForPurchase {
            item.purchaseItem()
        }
        itemsQueuedForPurchase.removeAll()
        fetchItems()
    }
}
