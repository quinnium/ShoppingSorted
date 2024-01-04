//
//  MigrationManager.swift
//  ShoppingSorted
//
//  Created by Quinn on 30/12/2023.
//

import Foundation
import CoreData
import RealmSwift

// Class used solely to convert old legacy Core Data database items into Realm database items (deleting Core Data items after)
class MigrationManager {
    
    private let databaseManager                         = DatabaseManager()
    private let container                               = NSPersistentContainer(name: "SSModel")
    private let mainContext: NSManagedObjectContext
    private var coreDataMeals: [CDMeal]                 = []
    private var coreDataIngredients: [CDIngredient]     = []
    private var coreDataAisles: [CDAisle]               = []
    private var coreDataUnits: [CDUnit]                 = []
    
    init() {
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data \(error.localizedDescription)")
            }
        }
        mainContext = container.viewContext
    }
    
    func convertCoreDataObjectsInMemory() {
        
        // Check if migration has happened before
        guard PersistenceManager.getValue(forKey: PersistenceManager.Keys.hasMigratedFromCoreDataBool) as? Bool != true else {
            print("Data migration hss already occurred, so no need to migrate")
            return
        }
        
        // Create fetchRequests and fecth existing Core Data objects
        let cdMealFetchRequest          = CDMeal.fetchRequest()
        let cdIngredientFetchRequest    = CDIngredient.fetchRequest()
        let cdAisleFetchRequest         = CDAisle.fetchRequest()
        let cdUnitFetchRequest          = CDUnit.fetchRequest()
        
        do {
            coreDataMeals       = try mainContext.fetch(cdMealFetchRequest)
            coreDataIngredients = try mainContext.fetch(cdIngredientFetchRequest)
            coreDataAisles      = try mainContext.fetch(cdAisleFetchRequest)
            coreDataUnits       = try mainContext.fetch(cdUnitFetchRequest)
        } catch(let error) {
            print(error)
            return
        }
        
        // Convert cdMeals -> (realm) Meals
        let convertedMeals: [RMMeal] = coreDataMeals.map { cdMeal in
            RMMeal(name: cdMeal.name ?? "", ingredients: [])
        }
        databaseManager.addNewMeals(meals: convertedMeals)
        print("successfully migrated \(coreDataMeals.count) Core Data 'Meals' into Realm")
        
        // Convert cdIngredients ->  (realm) ShoppingItem / (realm) Ingredient
        for cdIngredient in coreDataIngredients {
            if cdIngredient.meal == nil {
                // cdIngredient is a simple shopping list item
                databaseManager.addNewShoppingItem(name: cdIngredient.name ?? "",
                                                   quantity: cdIngredient.quantity,
                                                   unit: cdIngredient.unit ?? "",
                                                   aisle: cdIngredient.aisle ?? "",
                                                   forMeal: cdIngredient.mealTagForShoppingList)
            } else {
                // cdIngrdient is part of a saved meal
                // First get the correct Meal to save to
                let realmMeal = databaseManager.getAllMealsUnsorted().first(where: { meal in
                    meal.name == cdIngredient.meal?.name
                })
                if let realmMeal = realmMeal {
                    databaseManager.addIngredientToMeal(name: cdIngredient.name ?? "",
                                                        quantity: cdIngredient.quantity,
                                                        unit: cdIngredient.unit ?? "",
                                                        aisle: cdIngredient.aisle ?? "",
                                                        meal: realmMeal)
                }
            }
        }
        print("successfully migrated \(coreDataIngredients.count) Core Data 'Ingredients' into Realm")
        
        // Convert cdAisles -> RMAisles
        let realmAisles = coreDataAisles.map { cdAisle in
            RMAisle(name: cdAisle.name ?? "", order: Int(cdAisle.order))
        }
        databaseManager.saveAisles(aisles: realmAisles)
        print("successfully migrated \(coreDataAisles.count) Core Data 'Aisles' into Realm")

        // Convert cdUnits -> RMUnits
        let realmUnits = coreDataUnits.map { cdUnit in
            RMUnit(name: cdUnit.name ?? "", order: Int(cdUnit.order))
        }
        databaseManager.saveUnits(units: realmUnits)
        print("successfully migrated \(coreDataUnits.count) Core Data 'Unitz' into Realm")
        
        // All Core Data Items converted, now delete them from memory
        for ingredient in coreDataIngredients {
            mainContext.delete(ingredient)
        }
        for meal in coreDataMeals {
            mainContext.delete(meal)
        }
        for aisle in coreDataAisles {
            mainContext.delete(aisle)
        }
        for unit in coreDataUnits {
            mainContext.delete(unit)
        }
        try? mainContext.save()
        print("Core Data Objects deleted")
        
        // Now delete the CoreData Container
        deleteCoreDataContainer()
        
        // Update user defaults to log that a migration has occurred
        PersistenceManager.save(value: true, forKey: PersistenceManager.Keys.hasMigratedFromCoreDataBool)
        print("Updated persistence manager to reflect migration has occured")
    }
    
    private func deleteCoreDataContainer() {
        let persistentStoreCoordinator = container.persistentStoreCoordinator
        guard let storeURL = persistentStoreCoordinator.persistentStores.first?.url else {
            print("No persistent store found to delete")
            return
        }
        do {
            try persistentStoreCoordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: nil)
            print("Persistent store deleted successfully")
        } catch {
            print("Error deleting persistent store: \(error.localizedDescription)")
        }
    }
}

// Legacy CoreData files, only relevant for migration. Can eventually (once sure all users have migrated) be deleted
class CDMeal: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDMeal> {
        return NSFetchRequest<CDMeal>(entityName: "Meal")
    }
    @NSManaged public var name: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var ingredients: NSOrderedSet?
}

class CDIngredient: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDIngredient> {
        return NSFetchRequest<CDIngredient>(entityName: "Ingredient")
    }

    @NSManaged public var aisle: String?
    @NSManaged public var dateCreated: Date?
    @NSManaged public var name: String?
    @NSManaged public var quantity: Double
    @NSManaged public var unit: String?
    @NSManaged public var purchased: Date?
    @NSManaged public var meal: CDMeal?
    @NSManaged public var mealTagForShoppingList: String?
}

class CDAisle: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDAisle> {
        return NSFetchRequest<CDAisle>(entityName: "Aisle")
    }

    @NSManaged public var name: String?
    @NSManaged public var order: Int16
}

class CDUnit: NSManagedObject, Identifiable {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUnit> {
        return NSFetchRequest<CDUnit>(entityName: "Unit")
    }

    @NSManaged public var name: String?
    @NSManaged public var order: Int16
}

