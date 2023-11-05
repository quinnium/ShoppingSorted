//
//  EditUnitsAndAislesViewModel.swift
//  ShoppingSorted
//
//  Created by Quinn on 06/09/2023.
//

import Foundation

final class EditUnitsAndAislesViewModel: ObservableObject {
    
    var aisles: [String] = []
    var units: [String]  = []
    private let databaseManager     = DatabaseManager()
    var bottomOfAislesViewID        = UUID()
    var bottomOfUnitsViewID         = UUID()
    
    init() {
        aisles  = databaseManager.getAisles().map { $0.name }
        units   = databaseManager.getUnits().map { $0.name }
    }
    
    var isValidToSave: Bool {
        aisles.count > 0 && // at least one aisle
        units.count > 0 && // at least one unit
        aisles.allSatisfy {$0.count > 0} && // no empty aisles
        units.allSatisfy {$0.count > 0} && // no empty units
        Set(aisles).count == aisles.count && // all unique
        Set(units).count == units.count // all unique
    }
    
    func addNewAisle() {
        aisles.append("")
    }
    
    func addNewUnit() {
        units.append("")
    }
    
    func moveAisle(indices: IndexSet, newOffset: Int) {
        aisles.move(fromOffsets: indices, toOffset: newOffset)
    }
    
    func moveUhits(indices: IndexSet, newOffset: Int) {
        units.move(fromOffsets: indices, toOffset: newOffset)
    }
    
    func deleteAisle(indexSet: IndexSet) {
        aisles.remove(atOffsets: indexSet)
    }
    
    func deleteUnit(indexSet: IndexSet) {
        units.remove(atOffsets: indexSet)
    }
    
    func saveUnitsAndAisles() {
        guard isValidToSave else {
            // TODO: highlight problem lines
            print("invalid form")
            return
        }
        var newAisles: [Aisle] = []
        for (index, name) in aisles.enumerated() {
            let aisle = Aisle(name: name, order: index)
            newAisles.append(aisle)
        }
        databaseManager.saveAisles(aisles: newAisles)
        var newUnits: [Unit] = []
        for (index, name) in units.enumerated() {
            let unit = Unit(name: name, order: index)
            newUnits.append(unit)
        }
        databaseManager.saveUnits(units: newUnits)
    }
}
