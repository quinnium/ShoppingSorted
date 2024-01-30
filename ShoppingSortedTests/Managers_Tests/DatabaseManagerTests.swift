//
//  DatabaseManagerTests.swift
//  ShoppingSortedTests
//
//  Created by Quinn on 28/01/2024.
//

import XCTest
@testable import ShoppingSorted

final class DatabaseManagerTests: XCTestCase {

    var sut: DatabaseManager!
    
    override func setUp() {
        super.setUp()
        sut = DatabaseManager(forTesting: true)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_GetAllMealsUnsorted() {
        // Arrange
        let testMealOne = RMMeal(name: "Test One", ingredients: [])
        let testMealTwo = RMMeal(name: "Test Two", ingredients: [])
        sut.addNewMeals(meals: [testMealOne, testMealTwo])
        
        // Act
        let retrievedMeals = sut.getAllMealsUnsorted()
        let retrievedCount = retrievedMeals.count
        let expectedCount = 2
        let indexOfMealOne = retrievedMeals.first { $0.name == "Test One" }
        
        // Assert
        XCTAssertEqual(retrievedCount, expectedCount, "Retrieved Meals count does not match the expected number of retrieved meals")
        XCTAssertNotNil(indexOfMealOne, "At leats one of the meals saved was not retrieved")
    }
    
    func test_AddNewMeal() {
        // Arrange
        let testMeal = RMMeal(name: "TestAddMeal", ingredients: [])
        sut.addNewMeal(meal: testMeal, completion: {})
        
        // Act
        let retrievedMeals = sut.getAllMealsUnsorted()
        let retrievedMealsCount = retrievedMeals.count
        let retrievedMealName = retrievedMeals.first?.name
        let expectedCount = 1
        let expectedMealName = "TestAddMeal"
        
        // Assert
        XCTAssertEqual(retrievedMealsCount, expectedCount, "Retrieved more meals than the 1 expected")
        XCTAssertEqual(retrievedMealName, expectedMealName, "Retrieved meal has a different name than the meal saved")
    }
    
    func test_UpdateMealName() {
        // Arrange
        let testMeal = RMMeal(name: "TestMeal", ingredients: [])
        sut.addNewMeal(meal: testMeal, completion: {})

        // Act
        sut.updateMealName(meal: testMeal, newName: "TestMeal New Name")
        let retrievedMeal = sut.getAllMealsUnsorted()
        
        // Assert
        XCTAssertEqual(retrievedMeal.first?.name, "TestMeal New Name", "Result of change of name is not as expected")
    }
    
    func test_DeleteMeal_UsingMeal() {
        // Arrange
        let testMeal = RMMeal(name: "TestMealForDeletion", ingredients: [])
        sut.addNewMeal(meal: testMeal, completion: {})
        
        // Act
        sut.deleteMeal(meal: testMeal)
        let retrievedMeals = sut.getAllMealsUnsorted()
        
        // Assert
        XCTAssertTrue(retrievedMeals.isEmpty, "After deleting the saved meal, at least one meal was able to be retrieved, whereas none were expected")
    }
    
    func test_DeleteMeal_UsingID() {
        // Arrange
        let testMeal = RMMeal(name: "TestMealForDeletion", ingredients: [])
        sut.addNewMeal(meal: testMeal, completion: {})
        
        // Act
        sut.deleteMeal(id: testMeal.id)
        let retrievedMeals = sut.getAllMealsUnsorted()
        
        // Assert
        XCTAssertTrue(retrievedMeals.isEmpty, "After deleting the saved meal, at least one meal was able to be retrieved, whereas none were expected")
    }
    
    func test_DeleteIngredients() {
        // Arrange
        let testIngredients = [
        RMIngredient(name: "Ingredient 1", quantity: 1, unit: "each", aisle: "aisle"),
        RMIngredient(name: "Ingredient 2", quantity: 2, unit: "each", aisle: "aisle")]
        let testMeal = RMMeal(name: "Test Meal", ingredients: testIngredients)
        
        // Act
        sut.deleteIngredients(from: testMeal, at: IndexSet(integer: 0))
        
        // Assert
        XCTAssert(testMeal.ingredients.count == 1, "Resulting ingredients array is expected to have one element, but had more or less than this instead")
        XCTAssert(testMeal.ingredients.first?.name == "Ingredient 2", "The wrong ingredient was deleted from the array")
    }
    
    func test_UpdateIngredientForMeal() {
        // Arrange
        let testIngredient = RMIngredient(name: "Ingredient 1", quantity: 1, unit: "each", aisle: "aisle")
        let testMeal = RMMeal(name: "Test meal", ingredients: [testIngredient])
        sut.addNewMeal(meal: testMeal, completion: {})

        // Act
        sut.updateIngredientForMeal(ingredient: testIngredient, name: "Ingredient 2", quantity: 2, unit: "kg", aisle: "Other")
        
        // Assert
        XCTAssertEqual(testIngredient.name, "Ingredient 2")
        XCTAssertEqual(testIngredient.quantity, 2)
        XCTAssertEqual(testIngredient.unit, "kg")
        XCTAssertEqual(testIngredient.aisle, "Other")
    }
    
    func test_addIngredientToMeal() {
        // Arrange
        let testMeal = RMMeal(name: "Test meal", ingredients: [])
        sut.addNewMeal(meal: testMeal, completion: {})

        // Act
        sut.addIngredientToMeal(name: "Test Ingredient", quantity: 1, unit: "ml", aisle: "Test Aisle", meal: testMeal)
        
        // Assert
        XCTAssert(testMeal.ingredients.count == 1)
        XCTAssert(testMeal.ingredients.first?.name == "Test Ingredient")
    }
    
    func test_GetUnits() {
        let units = sut.getUnits()
        XCTAssert(units.count > 0)
    }
    
    func test_GetAisles() {
        let aisles = sut.getAisles()
        XCTAssert(aisles.count > 0)
    }
    
    func test_GetShoppingItems() {
        // Arrange
        sut.addNewShoppingItem(name: "testName", quantity: 1, unit: "testUnit", aisle: "testAisle", forMeal: nil)
        // Act
        let items = sut.getShoppingItems(purchased: false)
        
        // Assert
        XCTAssertTrue(items.count == 1, "Incorrect number of items returned (should only be one)")
        XCTAssertEqual(items.first?.name, "testName", "Item returned is different from item that was arranged (expected)")
    }
    
    func test_AddNewShoppingItem() {
        sut.addNewShoppingItem(name: "testItem", quantity: 2, unit: "testUnit", aisle: "testAisle", forMeal: "forTestMeal")
        let items = sut.getShoppingItems(purchased: false)
        XCTAssert(items.count == 1, "Incorrect number of items returned (should only be one)")
        XCTAssertEqual(items.first?.forMeal, "forTestMeal", "Item returned is different from item that was arranged (expected)")
    }
    
    func test_UpdateShoppingItem() {
        // Arrange
        sut.addNewShoppingItem(name: "itemOne", quantity: 3, unit: "unitOne", aisle: "aisleOne", forMeal: nil)
        let originalItems = sut.getShoppingItems(purchased: false)
        XCTAssert(originalItems.count == 1, "Cannot continue with test, as Incorrect number of items returned (should only be one)")
        
        // Act
        sut.updateShoppingItem(item: originalItems.first!, name: "itemOneUpdated", quantity: 33, unit: "unitOneUpdated", aisle: "aisleOneUpdated")
        let updatedItems = sut.getShoppingItems(purchased: false)
        XCTAssert(updatedItems.count == 1, "Cannot continue with test, as Incorrect number of items returned (should only be one)")
        
        // Assert
        XCTAssertEqual(updatedItems.first!.name, "itemOneUpdated", "Item returned does not appear to have been updatd")
    }
    
    func test_getAllPurchasableItemsUnsorted() {
        // Arrange
        sut.addNewMeal(meal: RMMeal(name: "TestMeal", ingredients: [RMIngredient(name: "testIngredient", quantity: 4, unit: "testUnit", aisle: "testAisle")]), completion: {})
        sut.addNewShoppingItem(name: "testShoppingItem", quantity: 5, unit: "testUnit", aisle: "testAisle", forMeal: nil)
        
        // Act
        let items = sut.getAllPurchasableItemsUnsorted()
        let indexOftestIngredient = items.first { $0.name == "testIngredient" }
        let indexOftestShoppingItem = items.first { $0.name == "testShoppingItem" }
        
        // Assert
        XCTAssert(items.count == 2)
        XCTAssertNotNil(indexOftestIngredient, "the testIngredient item created was not returned")
        XCTAssertNotNil(indexOftestShoppingItem, "the testShoppingItem item created was not returned")
    }
    
    func test_SaveAisles() {
        // Arrange
        let aislesToSave = [
            RMAisle(name: "aisleOne", order: 1),
            RMAisle(name: "aisleTwo", order: 2)
        ]
        
        // Act
        sut.saveAisles(aisles: aislesToSave)
        let aislesReturned = sut.getAisles().sorted { $0.order < $1.order }
        
        // Assert that the AIsles Rteurned match the Aisles that were saved
        XCTAssert(aislesReturned.count == 2)
        XCTAssertEqual(aislesReturned[0].name, aislesToSave[0].name)
        XCTAssertEqual(aislesReturned[0].order, aislesToSave[0].order)
        XCTAssertEqual(aislesReturned[1].name, aislesToSave[1].name)
        XCTAssertEqual(aislesReturned[1].order, aislesToSave[1].order)
    }
    
    func test_SaveUnits() {
        // Arrange
        let unitsToSave = [
            RMUnit(name: "aisleOne", order: 1),
            RMUnit(name: "aisleTwo", order: 2)
        ]
        
        // Act
        sut.saveUnits(units: unitsToSave)
        let unitsReturned = sut.getUnits().sorted { $0.order < $1.order }
        
        // Assert that the AIsles Rteurned match the Aisles that were saved
        XCTAssert(unitsReturned.count == 2)
        XCTAssertEqual(unitsReturned[0].name, unitsToSave[0].name)
        XCTAssertEqual(unitsReturned[0].order, unitsToSave[0].order)
        XCTAssertEqual(unitsReturned[1].name, unitsToSave[1].name)
        XCTAssertEqual(unitsReturned[1].order, unitsToSave[1].order)
    }

}
