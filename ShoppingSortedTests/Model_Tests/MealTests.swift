//
//  MealTests.swift
//  ShoppingSortedTests
//
//  Created by Quinn on 30/01/2024.
//

import XCTest
@testable import ShoppingSorted

final class MealTests: XCTestCase {
    
    var databaseManager: DatabaseManager!
    
    override func setUp() {
        super.setUp()
        databaseManager = DatabaseManager(forTesting: true)
    }
    
    override func tearDown() {
        databaseManager = nil
        super.tearDown()
    }
    
    func test_updateName() {
        // Arrange
        let newMeal = RMMeal(name: "TestName", ingredients: [], dateCreated: Date())
        databaseManager.addNewMeal(meal: newMeal, completion: {})
        // Act
        newMeal.updateName(name: "UpdatedName")
        let meals = databaseManager.getAllMealsUnsorted()
        // Assert
        XCTAssert(meals.count == 1, "Only one meal should be returned from database")
        XCTAssert(meals.first!.name == "UpdatedName", "name did not update correctly")
    }
}
