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

    func printRealmFilePath() {
        let path = realm.configuration.fileURL
        print("Log: Main Realm database at: \(path?.description ?? "not found")")
    }
    
    func getAllMealsUnsorted() -> [Meal] {
        let results = realm.objects(Meal.self)
        return Array(results)
    }
    
    func addNewMeal(meal: Meal, completion: @escaping () -> Void) {
        realm.beginWrite()
        realm.add(meal)
        commitChanges()
        completion()
    }
    
    func addNewMeals(meals: [Meal]) {
        realm.beginWrite()
        for meal in meals {
            realm.add(meal)
        }
        commitChanges()
    }
    
    func updateMealName(meal: Meal, newName: String) {
        realm.beginWrite()
        meal.name = newName
        commitChanges()
    }
    
    func deleteMeal(meal: Meal) {
        realm.beginWrite()
        for ingredient in meal.ingredients {
            realm.delete(ingredient)
        }
        realm.delete(meal)
        commitChanges()
    }
    
    func deleteMeal(id: ObjectId) {
        guard let meal = realm.object(ofType: Meal.self, forPrimaryKey: id) else { return }
        realm.beginWrite()
        realm.delete(meal)
        commitChanges()
    }
    
    func deleteIngredients(from meal: Meal, at indexSet: IndexSet) {
        realm.beginWrite()
        meal.ingredients.remove(atOffsets: indexSet)
        commitChanges()
    }
    
    func updateIngredientForMeal(ingredient: Ingredient, name: String, quantity: Double, unit: String, aisle: String) {
        if let ingredient = realm.object(ofType: Ingredient.self, forPrimaryKey: ingredient.id) {
            realm.beginWrite()
            ingredient.name = name
            ingredient.quantity = quantity
            ingredient.unit = unit
            ingredient.aisle = aisle
            commitChanges()
        }
    }
    
    func addIngredientToMeal(name: String, quantity: Double, unit: String, aisle: String, meal: Meal) {
        if let meal = realm.object(ofType: Meal.self, forPrimaryKey: meal.id) {
            let ingredient = Ingredient(name: name, quantity: quantity, unit: unit, aisle: aisle)
            realm.beginWrite()
            meal.ingredients.append(ingredient)
            commitChanges()
        }
    }
    
    func getUnits() -> [Unit] {
        let units = realm.objects(Unit.self).sorted { $0.order < $1.order }
        if units.count < 1 {
            let defaultUnits = Constants.DefaultValues.units
            realm.beginWrite()
            for index in 0..<defaultUnits.count {
                realm.add(Unit(name: defaultUnits[index], order: index))
            }
            commitChanges()
            return getUnits()
        }
        return units
    }
    
    func getAisles() -> [Aisle] {
        let aisles = realm.objects(Aisle.self).sorted { $0.order < $1.order }
        if aisles.count < 1 {
            let defaultAisles = Constants.DefaultValues.aisles
            realm.beginWrite()
            for index in 0..<defaultAisles.count {
                realm.add(Aisle(name: defaultAisles[index], order: index))
            }
            commitChanges()
            return getAisles()
        }
        return aisles
    }
    
    func getShoppingItems(purchased: Bool) -> [ShoppingItem] {
        realm.objects(ShoppingItem.self).filter { $0.purchased == purchased }
    }
  
    func addNewShoppingItem(name: String, quantity: Double, unit: String, aisle: String, forMeal: String?) {
        realm.beginWrite()
        let shoppingItem = ShoppingItem(name: name, quantity: quantity, unit: unit, aisle: aisle, forMeal: forMeal)
        realm.add(shoppingItem)
        commitChanges()
    }
    
    func updateShoppingItem(item: ShoppingItem, name: String, quantity: Double, unit: String, aisle: String) {
        if let item = realm.object(ofType: ShoppingItem.self, forPrimaryKey: item.id) {
            realm.beginWrite()
            item.name       = name
            item.quantity   = quantity
            item.unit       = unit
            item.aisle      = aisle
            commitChanges()
        }
    }
    
    func getAllPurchasableItemsUnsorted() -> [PurchasableItem] {
        let ingredients = realm.objects(Ingredient.self)
        let shoppingItems = realm.objects(ShoppingItem.self)
        var itemsToReturn: [PurchasableItem] = []
        itemsToReturn.append(contentsOf: Array(ingredients))
        itemsToReturn.append(contentsOf: Array(shoppingItems))
        return itemsToReturn
    }
    
    func developerCreateBlankMeal(withName name: String = "", withIngredients: Bool) {
        var ingredients: [Ingredient] = []
        if withIngredients {
            let amount = Int.random(in: 1...7)
            for _ in 1...amount {
                let newIngredient = Ingredient(name: Constants.testMealIngredients.randomElement()!,
                                               quantity: Double(Int.random(in: 1...5)),
                                               unit: Constants.DefaultValues.units.randomElement()!,
                                               aisle: Constants.DefaultValues.aisles.randomElement()!)
                ingredients.append(newIngredient)
            }
        }
        realm.beginWrite()
        let newMeal = Meal(name: name, ingredients: ingredients)
        realm.add(newMeal)
        commitChanges()
    }
  
    func developerDeleteAllObjects() {
        realm.beginWrite()
        realm.deleteAll()
        commitChanges()
    }
    
    func saveAisles(aisles newAisles: [Aisle]) {
        let existingAisles = realm.objects(Aisle.self)
        realm.beginWrite()
        realm.delete(existingAisles)
        realm.add(newAisles)
        commitChanges()
    }

    func saveUnits(units newUnits: [Unit]) {
        let existingUnits = realm.objects(Unit.self)
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
