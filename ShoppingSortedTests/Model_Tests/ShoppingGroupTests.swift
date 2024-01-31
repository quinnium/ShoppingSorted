//
//  ShoppingGroupTests.swift
//  ShoppingSortedTests
//
//  Created by Quinn on 30/01/2024.
//

import XCTest
@testable import ShoppingSorted

final class ShoppingGroupTests: XCTestCase {

    func test_initialisation_fails_when_not_common_name() {
        // Arrange
        let itemOne     = RMShoppingItem(name: "name", quantity: 0, unit: "g", aisle: "")
        let itemTwo     = RMShoppingItem(name: "Name", quantity: 0, unit: "g", aisle: "")
        // Act
        let newGroup    = ShoppingGroup(items: [itemOne, itemTwo])
        // Assert
        XCTAssertNil(newGroup, "should be nil becuase items' names were not the same")
    }
    
    func test_initialisation_fails_when_not_common_unit() {
        // Arrange
        let itemOne     = RMShoppingItem(name: "", quantity: 0, unit: "Kg", aisle: "")
        let itemTwo     = RMShoppingItem(name: "", quantity: 0, unit: "kg", aisle: "")
        // Act
        let newGroup    = ShoppingGroup(items: [itemOne, itemTwo])
        // Assert
        XCTAssertNil(newGroup, "should be nil becuase items' units were not the same")
    }
    
    func test_initialisation_success_when_common_name_and_unit() {
        // Arrange
        let itemOne     = RMShoppingItem(name: "name", quantity: 0, unit: "g", aisle: "")
        let itemTwo     = RMShoppingItem(name: "name", quantity: 0, unit: "g", aisle: "")
        // Act
        let newGroup    = ShoppingGroup(items: [itemOne, itemTwo])
        // Assert
        XCTAssertNotNil(newGroup, "should be not be nil becuase items' names and units were the same")
    }
}
