//
//  CoreDataManager.swift
//  ShoppingSorted
//
//  Created by Quinn on 25/03/2023.
//

import CoreData

// Singleton class
class DataManager {
    
    static let shared       = DataManager()
    private let container   = NSPersistentContainer(name: "SSModel")
    let mainContext: NSManagedObjectContext
    // Scratch Context available to use to perform CoreData changes that *may* need to be discarded (instead of saved)
    let scratchContext: NSManagedObjectContext
    
    private init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data \(error.localizedDescription)")
            }
        }
        mainContext             = container.viewContext
        scratchContext          = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        scratchContext.parent   = mainContext
    }
    
    
    func fetchAisles() -> [String] {
        var aislesInMemory: [Aisle] = []
        let fetchRequest            = Aisle.fetchRequest()
        do {
            aislesInMemory = try mainContext.fetch(fetchRequest)
        }
        catch { print("Failed to fetch aisles in memory \(error.localizedDescription)")
        }
        
        if aislesInMemory.count > 0 {
            aislesInMemory.sort { $0.order < $1.order }
            return aislesInMemory.map{ $0.name ?? "" }
        }
        else {
            for (index, aisle) in DefaultValues.aisles.enumerated() {
                let newAisle        = Aisle(context: mainContext)
                newAisle.name       = aisle
                newAisle.order      = Int16(index)
            }
            saveContext()
            return DefaultValues.aisles
        }
    }
    
    
    func fetchUnits() -> [String] {
        var unitsInMemory: [Unit]   = []
        let fetchRequest            = Unit.fetchRequest()
        do {
            unitsInMemory = try mainContext.fetch(fetchRequest)
        }
        catch { print("Failed to fetch units in memory \(error.localizedDescription)")
        }
        
        if unitsInMemory.count > 0 {
            unitsInMemory.sort { $0.order < $1.order }
            return unitsInMemory.map{ $0.name ?? "" }
        }
        else {
            for (index, unit) in DefaultValues.units.enumerated() {
                let newUnit         = Unit(context: mainContext)
                newUnit.name        = unit
                newUnit.order       = Int16(index)
            }
            saveContext()
            return DefaultValues.units
        }
    }
    
    
    func fetchAllPreviousIngredientsOldestFirst() -> [Ingredient] {
        var allIngredients: [Ingredient]    = []
        let fetchRequest                    = Ingredient.fetchRequest()
        do {
            allIngredients = try mainContext.fetch(fetchRequest)
            allIngredients.sort { $0.dateCreated ?? Date() < $1.dateCreated ?? Date() }
            print("All past ingredients fetched")
        }
        catch {
            print("Error fetching all past ingredients \(error.localizedDescription)")
        }
        return allIngredients
    }
    
    
    func addIngredientToShoppingList(name: String, aisle: String, quantity: Double, unit: String) {
        let newItem         = Ingredient(context: mainContext)
        newItem.name        = name
        newItem.aisle       = aisle
        newItem.quantity    = quantity
        newItem.unit        = unit
        newItem.dateCreated = Date()
        saveContext()
    }

    
    func addIngredientToMeal(meal: Meal, name: String, aisle: String, quantity: Double, unit: String) {
        let newItem         = Ingredient(context: mainContext)
        newItem.name        = name
        newItem.aisle       = aisle
        newItem.quantity    = quantity
        newItem.unit        = unit
        newItem.dateCreated = Date()
        newItem.meal        = meal
        meal.addToIngredients(newItem)
        saveContext()
    }
    
    
    func updateExistingIngredient(existingIngredient: Ingredient, name: String, aisle: String, quantity: Double, unit: String) {
        existingIngredient.name = name
        existingIngredient.aisle = aisle
        existingIngredient.quantity = quantity
        existingIngredient.unit = unit
        saveContext()
    }
        

    func saveAislesList(aisles: [String]) {
        let request     = Aisle.fetchRequest()
        var existingAisles: [Aisle] = []
        do {
            existingAisles = try mainContext.fetch(request)
        }
        catch {
            print("error fetching items \(error.localizedDescription)")
        }
        // Delete Exiting items
        for item in existingAisles {
            mainContext.delete(item)
        }
        // Save displayed Items
        for (index, name) in aisles.enumerated() {
            let newItem     = Aisle(context: mainContext)
            newItem.order   = Int16(index)
            newItem.name    = name
        }
        saveContext()
    }

    
    func saveUnitsList(units: [String]) {
        let request     = Unit.fetchRequest()
        var existingUnits: [Unit] = []
        do {
            existingUnits = try mainContext.fetch(request)
        }
        catch {
            print("error fetching items \(error.localizedDescription)")
        }
        // Delete Exiting items
        for item in existingUnits {
            mainContext.delete(item)
        }
        // Save displayed Items
        for (index, name) in units.enumerated() {
            let newItem     = Unit(context: mainContext)
            newItem.order   = Int16(index)
            newItem.name    = name
        }
        saveContext()
    }
    
    
    func fetchUnpurchasedShoppingListItems() -> [Ingredient] {
        var unpurchasedShoppingItems: [Ingredient]  = []
        let shoppingItemFetchRequest                = Ingredient.fetchRequest()
        shoppingItemFetchRequest.predicate          = NSPredicate(format: "purchased == nil && meal == nil")
        do {
            unpurchasedShoppingItems               = try mainContext.fetch(shoppingItemFetchRequest)
        }
        catch {
            print("Failed to fetch shoppingItems \(error.localizedDescription)")
        }
        return unpurchasedShoppingItems
    }

    
    func fetchPreviouslyPurchasedShoppingListItems() -> [Ingredient] {
        var purchasedShoppingItems: [Ingredient]  = []
        let fetchRequest            = Ingredient.fetchRequest()
        fetchRequest.predicate      = NSPredicate(format: "NOT purchased == nil && meal == nil")
        let oldestDateAcceptable    = Calendar.autoupdatingCurrent.date(byAdding: .day, value: -1, to: Date())
        do {
            // Fetch, but also filter results for only those meeting the 'OldestDateAcceptable' filter
            purchasedShoppingItems = try mainContext.fetch(fetchRequest)
                .filter { $0.purchased ?? Date() > oldestDateAcceptable ?? Date() }
                .sorted { $0.purchased ?? Date() > $1.purchased ?? Date() }
        }
        catch {
            print("Failed to fetch shoppingItems \(error.localizedDescription)")
        }
        return purchasedShoppingItems
    }
    
    
    func addRandomShoppingItem() {
        let newItem         = Ingredient(context: mainContext)
        newItem.name        = DefaultValues.names.randomElement()!
        newItem.aisle       = DefaultValues.aisles.randomElement()!
        newItem.quantity    = Double(Int.random(in: 1...6))
        newItem.unit        = DefaultValues.units.randomElement()!
        newItem.dateCreated = Date()
        saveContext()
    }
    
    
    func markShoppingItemsAsPurchased(items: [NSManagedObjectID]) {
        // TODO: objectid's might not work with cloudkit
        for item in items {
            let foundItem        = mainContext.object(with: item) as? Ingredient
            foundItem?.purchased = Date()
        }
        saveContext()
    }

    
    func markItemAsUnpurchased(item: Ingredient) {
        item.purchased = nil
        saveContext()
    }
    
    
    func deleteAllShoppingListItems() {
        let itemsInMemory = fetchUnpurchasedShoppingListItems()
        for item in itemsInMemory {
            mainContext.delete(item)
        }
        saveContext()
    }
    
    
    func fetchAllMeals() -> [Meal] {
        var meals: [Meal] = []
        let fetchRequest = Meal.fetchRequest()
        do {
            meals = try mainContext.fetch(fetchRequest).sorted {$0.name ?? "" < $1.name ?? ""}
        }
        catch {
            print("Failed to fetch meals \(error.localizedDescription)")
        }
        return meals
    }
    
    
    func createNewMeal(mealName: String) -> Meal {
        let newMeal         = Meal(context: mainContext)
        newMeal.name        = mealName
        newMeal.dateCreated = Date()
        saveContext()
        return newMeal
    }
    
    
    func addRandomMeal() {
        let newMeal                     = Meal(context: mainContext)
        newMeal.name                    = DefaultValues.mealNames.randomElement()
        var ingredients: [Ingredient]   = []
        for _ in 0..<Int.random(in: 1...6) {
            let newIngredient = Ingredient(context: mainContext)
            newIngredient.name = DefaultValues.items.randomElement()
            newIngredient.aisle = DefaultValues.aisles.randomElement()
            newIngredient.unit = DefaultValues.units.randomElement()
            newIngredient.quantity = (Double.random(in: 0...20)*10).rounded()/10
            newIngredient.dateCreated = Date()
            newIngredient.meal = newMeal
            ingredients.append(newIngredient)
        }
        newMeal.insertIntoIngredients(ingredients, at: NSIndexSet(index: 0))
        saveContext()
    }
    
    
    func deleteMeal(meal: Meal) {
        mainContext.delete(meal)
        saveContext()
    }
    
    
    func updateMealName(meal: Meal, newName: String) {
        meal.name = newName
        saveContext()
    }
    
    
    func removeIngredientsFromMeal(meal: Meal, ingredients: [Ingredient]) {
        for ingredient in ingredients {
            meal.removeFromIngredients(ingredient)
            mainContext.delete(ingredient)
        }
        saveContext()
    }
    
    
    func addIngredientsToShoppingLIst(ingredients: [Ingredient], multiplier: Double, mealTagForShoppingList: String? = nil) {
        for ingredient in ingredients {
            let ingredientToAdd         = Ingredient(context: mainContext)
            ingredientToAdd.name        = ingredient.name
            ingredientToAdd.aisle       = ingredient.aisle
            ingredientToAdd.unit        = ingredient.unit
            ingredientToAdd.quantity    = (ingredient.quantity * multiplier)
            ingredientToAdd.dateCreated = Date()
            ingredientToAdd.mealTagForShoppingList  = mealTagForShoppingList

        }
        saveContext()
    }
    
    
    func deleteAllMeals() {
        let meals = fetchAllMeals()
        for meal in meals {
            mainContext.delete(meal)
        }
        saveContext()
    }
    
    
    func saveContext() {
        guard mainContext.hasChanges else { return }
        do {
            try mainContext.save()
        }
        catch {
            print("Error saving context: \(error.localizedDescription)")
        }
    }
}
