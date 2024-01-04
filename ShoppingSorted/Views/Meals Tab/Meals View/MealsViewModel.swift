//
//  MealsViewModel.swift
//  ShoppingSorted
//
//  Created by Quinn on 28/08/2023.
//

import Foundation
import RealmSwift

final class MealsViewModel: ObservableObject {
    
    // View uses a tuple for main List, so as not to directly interact with live model objects
    @Published var mealsList: [(name: String, id: ObjectId)]    = []
    @Published var isAddingMeal: Bool                           = false
    @Published var newMealName: String                          = ""
    @Published var selectedMeal: RMMeal?                          = nil
    @Published var selectedMeals: Set<ObjectId>                 = []
    @Published var isSelecting: Bool                            = false
    @Published var isShowingExporter: Bool                      = false
    @Published var isShowingImporter: Bool                      = false
    var urlForExportableDocument: URL?
    private let databaseManager = DatabaseManager()
    private var meals: [RMMeal]   = [] {
        didSet {
            mealsList = meals.map { ($0.name, $0.id) }
        }
    }
    
    init() {
        fetchMeals()
    }
    
    func fetchMeals() {
        meals = databaseManager.getAllMealsUnsorted().sorted { $0.dateCreated < $1.dateCreated }
    }
    
    func getMeal(id: ObjectId) -> RMMeal? {
        meals.first { $0.id == id }
    }
    
    func addNewmeal() {
        guard newMealName.isNotEmpty else { return }
        let newMeal = RMMeal(name: newMealName, ingredients: [])
        databaseManager.addNewMeal(meal: newMeal) {
            self.newMealName = ""
            self.selectedMeal = newMeal
            self.fetchMeals()
        }
        
    }
    
    func deleteSelectedMeals() {
        for mealId in selectedMeals {
            databaseManager.deleteMeal(id: mealId)
        }
        isSelecting = false
        fetchMeals()
    }
    
    func didTapExport() {
        var mealsToExport: [RMMeal] = []
        for id in selectedMeals {
            if let meal = meals.first( where: { $0.id == id }) {
                mealsToExport.append(meal)
            }
        }
        let exportManager = ExportManager()
        urlForExportableDocument = exportManager.exportMealsToJSON(meals: mealsToExport)
        isShowingExporter = true
    }
    
    func importMealsFrom(from url: URL) {
        let importManager = ImportManager()
        importManager.importMeals(from: url) { numberSaved in
            self.fetchMeals()
        }
        
    }
}
