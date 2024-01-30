//
//  Array+ExtTests.swift
//  ShoppingSortedTests
//
//  Created by Quinn on 28/01/2024.
//

import XCTest
@testable import ShoppingSorted


final class Array_ExtTests: XCTestCase {


    func test_moveArrayElements() throws {
        var testArray = ["A", "B", "C", "D", "E"]
        testArray.move(at: 0, to: 4)
        let expectedArray = ["B", "C", "D", "E", "A"]
        XCTAssertEqual(testArray, expectedArray, "Moving the array element does not match expected result")
    }

}
