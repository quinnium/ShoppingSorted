//
//  RemindersManagerTests.swift
//  ShoppingSortedTests
//
//  Created by Quinn on 30/01/2024.
//

import XCTest
@testable import ShoppingSorted

final class RemindersManagerTests: XCTestCase {

    var sut: RemindersManager!
    
    override func setUp() {
        super.setUp()
        sut = RemindersManager()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}
