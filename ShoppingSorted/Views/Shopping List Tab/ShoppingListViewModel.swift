//
//  ShoppingListViewModel.swift
//  ShoppingSorted
//
//  Created by Quinn on 08/03/2023.
//

import CoreData

class ShoppingListViewModel: ObservableObject {
    

    private let dm = DataManager.shared
    @Published var isAddingIngredient                       = false
//    @Published var isEditingIngredient                      = false
    @Published var deleteSheetDisplayed                     = false
    @Published var shoppingList: [String: [GroupedIngredients]]  = [:]
    @Published var selectedIngredientToEdit: Ingredient?    = nil
    @Published var path: [GroupedIngredients] = []

    struct ShoppingGroup: Hashable {
        let name: String
        let unit: String
        var quantity: Double = 0
        var quantityString: String {
            let formatter                   = NumberFormatter()
            formatter.numberStyle           = .decimal
            formatter.maximumFractionDigits = 3
            return formatter.string(from: NSNumber(value: quantity)) ?? ""
        }
        var items: [Ingredient] = []
    }
    
    @Published var shoppingGroupDetailDisplayed: ShoppingGroup?    

    private var itemsMarkedAsPurchased: [NSManagedObjectID] = []
    private var timer: Timer?
    var aislesOrdered: [String] { sortAislesByDefaultAislesOrder(aisles: shoppingList.keys.sorted()) }
        
    init() {
        fetchAllItems()
    }
    
    
    func fetchAllItems() {
        let shoppingItems = dm.fetchUnpurchasedShoppingListItems()
        // Generate Shopping List Dictionary
        shoppingList.removeAll()
        
        // 1. Generate keys (aisles)
        let keys = Set(shoppingItems.compactMap { $0.aisle })
        
        for key in keys {
            // Start by filtering for each Aisle
            let ingredientsForAisle         = shoppingItems.filter { $0.aisle == key }
            
            shoppingList[key] = GroupingService.getGroupedIngredients(from: ingredientsForAisle)
        }
    }
    
    
    func addRandomShoppingItem() {
        dm.addRandomShoppingItem()
        fetchAllItems()
    }
    
  
    func purchaseGroupedItems(group: GroupedIngredients, toPurchase: Bool) {
        if toPurchase == false {
            for item in group.items {
                itemsMarkedAsPurchased.removeAll { $0 == item.objectID }
            }
        }
        else {
            for item in group.items {
                itemsMarkedAsPurchased.append(item.objectID)
            }
        }
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            self.dm.markShoppingItemsAsPurchased(items: self.itemsMarkedAsPurchased)
            self.fetchAllItems()
        }
        
    }
    
    
    func sortAislesByDefaultAislesOrder(aisles listAisles: [String]) -> [String] {
        // Function to order the aisles string array into a type of order est resembling the user's default aisles
        // If an aisle (of a shopping list item) is not found within defaults, then it is appended and sorted alphabetically
        let defaultAisles                           = dm.fetchAisles()
        var aislesFoundWithOrder: [(String, Int)]   = []
        var aislesNotFound: [String]                = []
        
        for listAisle in listAisles {
            if let indexFound = defaultAisles.firstIndex(of: listAisle) {
                aislesFoundWithOrder.append((listAisle,indexFound))
            }
            else {
                aislesNotFound.append(listAisle)
            }
        }
        aislesFoundWithOrder.sort { $0.1 < $1.1 }
        let aislesToReturn = aislesFoundWithOrder.map { $0.0 } + aislesNotFound.sorted()
        return aislesToReturn
    }
    
    
    func deleteAllShoppingItems() {
        dm.deleteAllShoppingListItems()
        fetchAllItems()
    }
}
