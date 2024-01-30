//
//  StringProtocol+ExtTests.swift
//  ShoppingSortedTests
//
//  Created by Quinn on 28/01/2024.
//

import XCTest
@testable import ShoppingSorted

final class StringProtocol_ExtTests: XCTestCase {

    func test_FirstUppercased() throws {
        let exampleString = "this is a Test string"
        let result = exampleString.firstUppercased
        let expected = "This is a Test string"
        XCTAssertEqual(result, expected, "firstUppercased function is not operating as intended")
    }
}
