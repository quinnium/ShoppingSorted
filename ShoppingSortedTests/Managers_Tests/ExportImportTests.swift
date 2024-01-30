//
//  ExportImportTests.swift
//  ShoppingSortedTests
//
//  Created by Quinn on 29/01/2024.
//

import XCTest
@testable import ShoppingSorted

final class ExportImportTests: XCTestCase {

    var databaseManager: DatabaseManager!
    var exportManager: ExportManager!
    var importmanager: ImportManager!
    
    override func setUp() {
        super.setUp()
        databaseManager = DatabaseManager(forTesting: true)
        exportManager   = ExportManager()
        importmanager   = ImportManager()
    }

    override func tearDown() {
        importmanager   = nil
        exportManager   = nil
        databaseManager = nil
        super.tearDown()
    }
    
    func test_ImportAndExport() {
        // Arrange
        let testIngredient = RMIngredient(name: "Ingredient", quantity: 1, unit: "unit", aisle: "aisle")
        let testMeals = [RMMeal(name: "mealOne", ingredients: [testIngredient]),
                         RMMeal(name: "mealTwo", ingredients: [testIngredient])]
        
        // Act
        let exportedURL = exportManager.exportMealsToJSON(meals: testMeals)
        
        // Assert
        XCTAssertNotNil(exportedURL, "url returned by export should not be nil, this implies a failed export")
        
        let expectation = XCTestExpectation(description: "Meals data exported and imported successfully")
        importmanager.importMeals(from: exportedURL!) { number in
            XCTAssert(number == 2, "a different numbe rof meals imported than expected (2 expected)")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
    }
}
