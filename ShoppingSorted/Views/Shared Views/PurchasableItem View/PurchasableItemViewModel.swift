//
//  PurchasableItemViewModel.swift
//  ShoppingSorted
//
//  Created by Quinn on 01/09/2023.
//

import Foundation
// TODO: add safety check to ensure itemUnit is actually on unitList, and aisle is on aisleList
// TODO: add notification in UI if ingredient loaded with aisle or unit that has since been deleted
class PurchasableItemViewModel: ObservableObject {
    
    enum ItemType {
        case newIngredient
        case existingIngredient
        case newShoppingItem
        case existingShoppingItem
    }
    
    private var item: PurchasableItem
    private var itemType: ItemType
    private var parentMeal: RMMeal?
    private let databaseManager: DatabaseManager    = DatabaseManager()
    private lazy var previouslyPurchasedItems: [String: (unit: String, aisle: String)] = {
        getAllPreviousItems()
    }()
    var searchresults: [String] {
        previouslyPurchasedItems.keys.sorted().filter { $0.range(of: itemName.trimmingCharacters(in: .whitespaces), options: .caseInsensitive) != nil }
    }
    @Published var unitList: [String]               = []
    @Published var aisleList: [String]              = []
    @Published var itemName: String                 = ""
    @Published var itemQuantity: Double             = 0
    @Published var itemUnit: String                 = ""
    @Published var itemAisle: String                = ""
    @Published var isEditingUnitsAndAisles: Bool    = false
    @Published var isShowingAlertInvalidAisle: Bool = false
    @Published var isShowingAlertInvalidUnit: Bool  = false
    var oldInvalidUnitName: String?
    var oldInvalidAisleName: String?
    var immediateFocusOnNameField: Bool {
        itemType == .newIngredient || itemType == .newShoppingItem
    }

    init(ingredient: RMIngredient?, parentMeal: RMMeal) {
        if ingredient == nil {
            itemType = .newIngredient
            item = RMIngredient(name: "", quantity: 0, unit: "", aisle: "")
        } else {
            itemType = .existingIngredient
            item = ingredient!
        }
        self.parentMeal = parentMeal
        loadUnitsAndAisles()
        propagateValues()
    }
    
    init(shoppingItem: RMShoppingItem?) {
        if shoppingItem == nil {
            itemType = .newShoppingItem
            item = RMShoppingItem(name: "", quantity: 0, unit: "", aisle: "")
        } else {
            itemType = .existingShoppingItem
            item = shoppingItem!
        }
        loadUnitsAndAisles()
        propagateValues()
    }
    
    var title: String {
        switch itemType {
            case .newIngredient:
                return "Add Ingredient"
            case .existingIngredient:
                return "Edit Ingredient"
            case .newShoppingItem:
                return "Add Item"
            case .existingShoppingItem:
                return "Edit Item"
        }
    }
    
    var addOrSaveButtonTitle: String {
        switch itemType {
            case .newIngredient:
                return "Add"
            case .existingIngredient:
                return "Save"
            case .newShoppingItem:
                return "Add"
            case .existingShoppingItem:
                return "Save"
        }
    }
    
    var isValidToSave: Bool {
        return (unitList.contains(itemUnit) &&
                aisleList.contains(itemAisle) &&
                itemQuantity > 0 &&
                !itemName.isEmpty)
    }
    
    func loadUnitsAndAisles() {
        let units   = databaseManager.getUnits()
        let aisles  = databaseManager.getAisles()
        unitList    = units.map { $0.name }
        aisleList   = aisles.map {$0.name}
    }
    
    // TODO: test these alerts by deleting unit and aisle once deletion funcitonality exists
    private func propagateValues() {
        itemName        = item.name
        itemQuantity    = item.quantity
        if unitList.contains(item.unit ) {
            itemUnit = item.unit
        } else {
            itemUnit = unitList.first ?? ""
        }
        if itemType == .existingIngredient || itemType == .existingShoppingItem {
            if !unitList.contains(itemUnit) {
                oldInvalidUnitName = itemUnit
                itemUnit = unitList.first ?? ""
                isShowingAlertInvalidUnit = true
            }
            itemAisle       = item.aisle
            if !aisleList.contains(itemAisle) {
                oldInvalidAisleName = itemAisle
                isShowingAlertInvalidAisle = true
            }
        }
    }
    
    private func getAllPreviousItems() -> [String : (unit: String, aisle: String)] {
        var items = databaseManager.getAllPurchasableItemsUnsorted()
        items.sort { $0.dateModified < $1.dateModified }
        var previousItemsDictionary: [String : (unit: String, aisle: String)] = [:]
        for item in items {
            previousItemsDictionary[item.name.lowercased()] = (unit: item.unit, aisle: item.aisle)
        }
        return previousItemsDictionary
    }
    
    func previousItemSelected(name: String) {
        guard let tuple = previouslyPurchasedItems[name] else { return }
        itemName = name.firstUppercased
        if unitList.contains(tuple.unit) {
            itemUnit = tuple.unit
        }
        if aisleList.contains(tuple.aisle) {
            itemAisle = tuple.aisle
        }
    }
    
    func primaryActionButtonPressed() {
        switch itemType {
            case .newIngredient:
                guard let parentMeal = parentMeal else { return }
                databaseManager.addIngredientToMeal(name: itemName,
                                                    quantity: itemQuantity,
                                                    unit: itemUnit,
                                                    aisle: itemAisle,
                                                    meal: parentMeal)
            case .existingIngredient:
                guard let ingredient = item as? RMIngredient else { return }
                databaseManager.updateIngredientForMeal(ingredient: ingredient,
                                                        name: itemName,
                                                        quantity: itemQuantity,
                                                        unit: itemUnit,
                                                        aisle: itemAisle)
            case .newShoppingItem:
                guard let _ = item as? RMShoppingItem else { return }
                databaseManager.addNewShoppingItem(name: itemName, 
                                                   quantity: itemQuantity,
                                                   unit: itemUnit,
                                                   aisle: itemAisle,
                                                   forMeal: nil)
            case .existingShoppingItem:
                guard let shoppingItem = item as? RMShoppingItem else { return }
                databaseManager.updateShoppingItem(item: shoppingItem, 
                                                   name: itemName,
                                                   quantity: itemQuantity,
                                                   unit: itemUnit,
                                                   aisle: itemAisle)
        }
    }
}

