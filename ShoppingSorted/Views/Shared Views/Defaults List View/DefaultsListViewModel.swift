//
//  DefaultsListViewModel.swift
//  ShoppingSorted
//
//  Created by Quinn on 19/05/2023.
//

import Foundation

class DefaultsListViewModel: ObservableObject {

    private let dm = DataManager.shared
    
    @Published var aisles: [String] = []
    @Published var units: [String] = []
    var addAisleID = UUID()
    var addUnitID = UUID()
    
    let addItemID       = UUID()

    var isValidToSave: Bool {
        aisles.count > 0 && // at least one aisle
        units.count > 0 && // at least one unit
        aisles.allSatisfy {$0.count > 0} && // no empty aisles
        units.allSatisfy {$0.count > 0} && // no empty units
        Set(aisles).count == aisles.count && // all unique
        Set(units).count == units.count // all unique
    }
    
    init() {
        loadEditableItems()
    }
    
    
    func loadEditableItems() {
        aisles = dm.fetchAisles()
        units = dm.fetchUnits()
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
    
    
    func saveItems() {
        guard isValidToSave else {
            // TODO: highlight problem lines
            print("invalid form")
            return
        }
        dm.saveAislesList(aisles: aisles)
        dm.saveUnitsList(units: units)
    }
    
}
