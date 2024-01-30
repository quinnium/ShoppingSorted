//
//  PersistenceManagerTests.swift
//  ShoppingSortedTests
//
//  Created by Quinn on 28/01/2024.
//

import XCTest
@testable import ShoppingSorted


final class PersistenceManagerTests: XCTestCase {

    func test_Save_And_Retrieve_From_Defaults() throws {
        let testKey = "TestKey"
        let testDate = Date()
        PersistenceManager.save(value: testDate, forKey: testKey)
        let retrievedValue = PersistenceManager.getValue(forKey: testKey) as? Date
        XCTAssertEqual(retrievedValue, testDate, "Value retrieved from User Defaults does not match the value saved")
    }
}
