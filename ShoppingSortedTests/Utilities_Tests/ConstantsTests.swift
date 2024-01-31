//
//  ConstantsTests.swift
//  ShoppingSortedTests
//
//  Created by Quinn on 28/01/2024.
//

import XCTest
import RealmSwift
@testable import ShoppingSorted

final class ConstantsTests: XCTestCase {
        
    func test_At_Least_One_DefaultAisle() {
        let minimumNumber       = 1
        let defaultAislesCount  = Constants.DefaultValues.aisles.count
        XCTAssertGreaterThanOrEqual(defaultAislesCount, minimumNumber, "There needs to be at least one default aisle stored")
    }

    func test_At_Least_One_DefaultUnit() {
        let minimumNumber       = 1
        let defaultUnitsCount   = Constants.DefaultValues.units.count
        XCTAssertGreaterThanOrEqual(defaultUnitsCount, minimumNumber, "There needs to be at least one default unit stored")
    }
    
    func test_All_Aisles_Are_Unique() {
        let defaultAisles       = Constants.DefaultValues.aisles
        let allAislesAreUnique  = areElementsUnique(defaultAisles)
        XCTAssertTrue(allAislesAreUnique, "All default aisles must be unique otherwise unexpected behaviour could occur")
    }
    
    func test_All_Units_Are_Unique() {
        let defaultUnits        = Constants.DefaultValues.units
        let allUnitsAreUnique   = areElementsUnique(defaultUnits)
        XCTAssertTrue(allUnitsAreUnique, "All default units must be unique otherwise unexpected behaviour could occur")
    }
    
    // Helper function to check if all elements in the array are unique
    func areElementsUnique<T: Hashable>(_ array: [T]) -> Bool {
        var set = Set<T>()
        for element in array {
            if set.contains(element) {
                return false
            }
            set.insert(element)
        }
        return true
    }
}
