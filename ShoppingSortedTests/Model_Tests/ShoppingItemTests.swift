//
//  ShoppingItemTests.swift
//  ShoppingSortedTests
//
//  Created by Quinn on 30/01/2024.
//

import XCTest
@testable import ShoppingSorted

final class ShoppingItemTests: XCTestCase {
    
    func test_ShoppingItem_initialised_as_unpurchased() {
        let item = RMShoppingItem(name: "", quantity: 0, unit: "", aisle: "")
        XCTAssert(item.purchased == false, "property should be false upon object instantiation")
        XCTAssert(item.purchasedDate == nil, "property should be nil upon object instantiation")
    }
    
    func test_PurchaseItem() {
        // Arrange
        let item = RMShoppingItem(name: "", quantity: 0, unit: "", aisle: "")
        // Act
        item.purchaseItem()
        // Assert
        XCTAssert(item.purchased == true, "property should be true after object's purchased method is called")
        XCTAssert(item.purchasedDate != nil, "property should not be nil after object's purchased method is called")
    }

    func test_unPurchaseItem() {
        // Arrange
        let item = RMShoppingItem(name: "", quantity: 0, unit: "", aisle: "")
        // Act
        item.purchaseItem()
        item.unPurchaseItem()
        // Assert
        XCTAssert(item.purchased == false, "property should be false after object's purchased method is called")
        XCTAssert(item.purchasedDate == nil, "property should be nil after object's purchased method is called")
    }
}
