//
//  DatabaseManager.swift
//  ShoppingSorted
//
//  Created by Quinn on 28/08/2023.
//

import Foundation
import RealmSwift

final class DatabaseManager {
    
    private var realm: Realm
    private var configurationPathName = "SmartShopping"
    
    init(forTesting: Bool = false) {
        var configuration: Realm.Configuration
        if forTesting {
            configuration = Realm.Configuration(inMemoryIdentifier: "SSInMemory")
        } else {
            configuration = Realm.Configuration.defaultConfiguration
            if configuration.fileURL != nil {
                configuration.fileURL!.deleteLastPathComponent()
                configuration.fileURL!.append(path: configurationPathName)
                configuration.fileURL!.appendPathExtension("realm")
                configuration.deleteRealmIfMigrationNeeded = true
            }
        }
        do {
            realm = try Realm(configuration: configuration)
        } catch {
            fatalError("failed to load Realm with configuration \(error)")
        }
    }

    func getAllMealsUnsorted() -> [RMMeal] {
        let results = realm.objects(RMMeal.self)
        return Array(results)
    }
    
    func addNewMeal(meal: RMMeal, completion: @escaping () -> Void) {
        realm.beginWrite()
        realm.add(meal)
        commitChanges()
        completion()
    }
    
    func addNewMeals(meals: [RMMeal]) {
        realm.beginWrite()
        for meal in meals {
            realm.add(meal)
        }
        commitChanges()
    }
    
    func updateMealName(meal: RMMeal, newName: String) {
        realm.beginWrite()
        meal.name = newName
        commitChanges()
    }
    
    func deleteMeal(meal: RMMeal) {
        realm.beginWrite()
        for ingredient in meal.ingredients {
            realm.delete(ingredient)
        }
        realm.delete(meal)
        commitChanges()
    }
    
    func deleteMeal(id: ObjectId) {
        guard let meal = realm.object(ofType: RMMeal.self, forPrimaryKey: id) else { return }
        realm.beginWrite()
        realm.delete(meal)
        commitChanges()
    }
    
    func deleteIngredients(from meal: RMMeal, at indexSet: IndexSet) {
        realm.beginWrite()
        meal.ingredients.remove(atOffsets: indexSet)
        commitChanges()
    }
    
    func updateIngredientForMeal(ingredient: RMIngredient, name: String, quantity: Double, unit: String, aisle: String) {
        if let ingredient = realm.object(ofType: RMIngredient.self, forPrimaryKey: ingredient.id) {
            realm.beginWrite()
            ingredient.name     = name
            ingredient.quantity = quantity
            ingredient.unit     = unit
            ingredient.aisle    = aisle
            commitChanges()
        }
    }
    
    func addIngredientToMeal(name: String, quantity: Double, unit: String, aisle: String, meal: RMMeal) {
        if let meal = realm.object(ofType: RMMeal.self, forPrimaryKey: meal.id) {
            let ingredient = RMIngredient(name: name, quantity: quantity, unit: unit, aisle: aisle)
            realm.beginWrite()
            meal.ingredients.append(ingredient)
            commitChanges()
        }
    }
    
    func getUnits() -> [RMUnit] {
        let units = realm.objects(RMUnit.self).sorted { $0.order < $1.order }
        if units.count < 1 {
            let defaultUnits = Constants.DefaultValues.units
            realm.beginWrite()
            for index in 0..<defaultUnits.count {
                realm.add(RMUnit(name: defaultUnits[index], order: index))
            }
            commitChanges()
            return getUnits()
        }
        return units
    }
    
    func getAisles() -> [RMAisle] {
        let aisles = realm.objects(RMAisle.self).sorted { $0.order < $1.order }
        if aisles.count < 1 {
            let defaultAisles = Constants.DefaultValues.aisles
            realm.beginWrite()
            for index in 0..<defaultAisles.count {
                realm.add(RMAisle(name: defaultAisles[index], order: index))
            }
            commitChanges()
            return getAisles()
        }
        return aisles
    }
    
    func getShoppingItems(purchased: Bool) -> [RMShoppingItem] {
        realm.objects(RMShoppingItem.self).filter { $0.purchased == purchased }
    }
  
    func addNewShoppingItem(name: String, quantity: Double, unit: String, aisle: String, forMeal: String?) {
        realm.beginWrite()
        let shoppingItem = RMShoppingItem(name: name, quantity: quantity, unit: unit, aisle: aisle, forMeal: forMeal)
        realm.add(shoppingItem)
        commitChanges()
    }
    
    func updateShoppingItem(item: RMShoppingItem, name: String, quantity: Double, unit: String, aisle: String) {
        if let item = realm.object(ofType: RMShoppingItem.self, forPrimaryKey: item.id) {
            realm.beginWrite()
            item.name       = name
            item.quantity   = quantity
            item.unit       = unit
            item.aisle      = aisle
            commitChanges()
        }
    }
    
    func getAllPurchasableItemsUnsorted() -> [PurchasableItem] {
        let ingredients                         = realm.objects(RMIngredient.self)
        let shoppingItems                       = realm.objects(RMShoppingItem.self)
        var itemsToReturn: [PurchasableItem]    = []
        itemsToReturn.append(contentsOf: Array(ingredients))
        itemsToReturn.append(contentsOf: Array(shoppingItems))
        return itemsToReturn
    }
    
    func saveAisles(aisles newAisles: [RMAisle]) {
        let existingAisles = realm.objects(RMAisle.self)
        realm.beginWrite()
        realm.delete(existingAisles)
        realm.add(newAisles)
        commitChanges()
    }

    func saveUnits(units newUnits: [RMUnit]) {
        let existingUnits = realm.objects(RMUnit.self)
        realm.beginWrite()
        realm.delete(existingUnits)
        realm.add(newUnits)
        commitChanges()
    }
    
    private func commitChanges() {
        do {
            try realm.commitWrite()
        } catch {
            print("Failed to commit changes to database: \(error)")
        }
    }
}
