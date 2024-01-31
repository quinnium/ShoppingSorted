//
//  Collection+ExtTests.swift
//  ShoppingSortedTests
//
//  Created by Quinn on 28/01/2024.
//

import XCTest
@testable import ShoppingSorted

final class Collection_ExtTests: XCTestCase {

    func test_isNotEmpty() {
        let emptyArray: [Any]       = []
        let emptyArrayIsNotEmpty    = emptyArray.isNotEmpty
        XCTAssertFalse(emptyArrayIsNotEmpty, "isNotEmpty should give a 'false' response for an empty collection")
        
        let arrayWithValues: [Any]      = [1, 2, 3]
        let arrayWithValuesIsNotEmpty   = arrayWithValues.isNotEmpty
        XCTAssertTrue(arrayWithValuesIsNotEmpty, "isNotEmpty should give a 'true' response for a collection with values")
    }
}
