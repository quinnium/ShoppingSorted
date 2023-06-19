//
//  ShoppingSortedTests.swift
//  ShoppingSortedTests
//
//  Created by Quinn on 18/06/2023.
//

import XCTest
@testable import ShoppingSorted

final class ShoppingSortedTests: XCTestCase {

    var vm: EditIngredientViewModel!
    
    override func setUp() {
        vm = EditIngredientViewModel(isAddingDirectlyToShoppingList: true, existingIngredient: nil, meal: nil)
    }
    
    override func tearDown() {
        vm = nil
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testResetFormWorks() {
        // Given - Arrange
        vm.itemName     = "Bread"
        vm.itemQuantity = 1000.00
        vm.itemUnit     = "g"
        vm.itemAisle    = "Frozen"
        
        // When - Act
        vm.resetForm()
        
        // Then - Assert
        XCTAssertTrue(vm.itemName       == "")
        XCTAssertTrue(vm.itemQuantity   == 0.00)
        XCTAssertTrue(vm.itemUnit       == vm.unitList.first ?? "")
        XCTAssertTrue(vm.itemAisle      == nil)
    }
    
    
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
