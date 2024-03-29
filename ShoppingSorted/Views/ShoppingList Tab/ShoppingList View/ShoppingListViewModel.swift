//
//  ShoppingListViewModel.swift
//  ShoppingSorted
//
//  Created by Quinn on 28/09/2023.
//

import Foundation

class ShoppingListViewModel: ObservableObject {
    
    @Published var aislesList: [String]                             = []
    @Published var shoppingGroupsDict: [String: [ShoppingGroup]]    = [:]
    @Published var isShowingPurchasedItems: Bool                    = false
    @Published var isShowingExportView: Bool                        = false
    @Published var isAddingNewShoppingItem: Bool                    = false
    @Published var navigationPath: [ShoppingGroup]                  = []
    @Published var itemSelectedForEditing: RMShoppingItem?
    
    private var shoppingItems: [RMShoppingItem]                     = []
    private let databaseManager                                     = DatabaseManager()
    private var itemsQueuedForPurchase: [RMShoppingItem]            = [] {
        didSet {
            timer?.invalidate()
            timer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false) { _ in
                self.purchaseItemsQueuedForPurchase()
            }
        }
    }
    private var timer: Timer?
    var titlesForExportedReminders: [String] {
        shoppingGroupsDict.values.flatMap { $0 }.map { "\($0.commonName), \($0.totalQuantity) \($0.commonUnit)" }
    }

    init() {
        fetchItems()
    }
    
    func fetchItems() {
        shoppingItems = databaseManager.getShoppingItems(purchased: false)
        setAisles()
        setShoppingGroupsDict()
        print("items fetched and sorted")
    }
    
    private func setAisles() {
        var itemAisleNames = Array(Set(shoppingItems.map { $0.aisle }))
        let storedAisles = databaseManager.getAisles()
        // Sort aisles into order (where possible) that matches 'storedAisles'
        var sortedAisleNames: [String] = []
        for index in 0..<storedAisles.count {
            for aisleName in itemAisleNames {
                if aisleName == storedAisles[index].name {
                    sortedAisleNames.append(aisleName)
                    itemAisleNames.removeAll { $0 == aisleName }
                }
            }
        }
        sortedAisleNames.append(contentsOf: itemAisleNames.sorted())
        aislesList = sortedAisleNames
    }
    
    private func setShoppingGroupsDict() {
        // Firstly, clear the old dictionary
        shoppingGroupsDict.removeAll()
        // For each Aisle section
        for aisle in aislesList {
            let itemsForAisle = shoppingItems.filter { $0.aisle == aisle }
            //Create tuple array of uique 'name' and 'unit' pairs
            var uniqueTupleArray: [(name: String, unit: String)] = []
            let uniqueNames = Set(itemsForAisle.map { $0.name })
            for name in uniqueNames {
                let uniqueUnitsForName = Set(itemsForAisle.filter { $0.name == name }.map { $0.unit })
                for unit in uniqueUnitsForName {
                    uniqueTupleArray.append((name: name, unit: unit))
                }
            }
            // Now tuple array is propagated we can use it to generate the array of items for each 'key' (aisle)
            for tuple in uniqueTupleArray {
                if let shoppingGroup = ShoppingGroup(items: itemsForAisle.filter{ $0.name == tuple.name && $0.unit == tuple.unit }) {
                    shoppingGroupsDict[aisle, default: []].append(shoppingGroup)
                }
            }
            
            // Sort the shoppingGroupsDict alphabetically for each aisle
            for (key, arrayOfItems) in shoppingGroupsDict {
                shoppingGroupsDict[key] = arrayOfItems.sorted { ($0.commonName, $0.commonUnit) < ($1.commonName, $1.commonUnit) }
            }
        }
    }
    
    func itemsMarkedAsPurchased(items: [RMShoppingItem]) {
        itemsQueuedForPurchase.append(contentsOf: items)
    }
    
    func itemsMarkedAsUnpurchased(items: [RMShoppingItem]) {
        for item in items {
            itemsQueuedForPurchase.removeAll { $0.id == item.id }
        }
    }
    
    private func purchaseItemsQueuedForPurchase() {
        for item in itemsQueuedForPurchase {
            item.purchaseItem()
        }
        itemsQueuedForPurchase.removeAll()
        fetchItems()
    }
    

}
