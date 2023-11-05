//
//  ShoppingGroupDetailViewmodel.swift
//  ShoppingSorted
//
//  Created by Quinn on 17/09/2023.
//

import Foundation

class ShoppingGroupDetailViewModel: ObservableObject {
 
    let groupsFromGroup: [ShoppingGroup]
    @Published var selectedItemForEditing: ShoppingItem?       = nil
    var selectedShoppingItemsQueue: [ShoppingItem]  = [] {
        didSet { purchaseItemsMarkedForPurchase() }
    }
    private var timer: Timer?
    
    init(group: ShoppingGroup) {
        for item in group.items {
            if let group = ShoppingGroup(items: [item]) {
                groupsFromGroup.append(group)
            }
        }
    }
    
    func groupMarkedAsPurchased(group: ShoppingGroup) {
        for item in group.items {
            selectedShoppingItemsQueue.append(item)
        }
    }
    
    func groupMarkedAsUnpurchased(group: ShoppingGroup) {
        for item in group.items {
            selectedShoppingItemsQueue.removeAll { $0 == item }
        }
    }
    
    
    private func purchaseItemsMarkedForPurchase() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { [weak self] timer in
            guard let self = self else { return }
            self.databaseManager.purchaseShoppingItems(items: self.selectedShoppingItemsQueue)
            self.loadItems()
            self.selectedShoppingItemsQueue.removeAll()
        }
    }
    
}
