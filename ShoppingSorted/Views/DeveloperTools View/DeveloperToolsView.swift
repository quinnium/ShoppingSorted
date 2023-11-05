//
//  DeveloperToolsView.swift
//  ShoppingSorted
//
//  Created by Quinn on 31/08/2023.
//

import SwiftUI

struct DeveloperToolsView: View {
    
    let databaseManager = DatabaseManager()
    
    var body: some View {
        HStack(spacing: 50) {
            Button("Add blank meal") {
                databaseManager.developerCreateBlankMeal(withName: Constants.testMealNames.randomElement()!, withIngredients: true)
            }
            .lineLimit(2)
            Button("Delete All Objects") {
                databaseManager.developerDeleteAllObjects()
            }
            .lineLimit(2)
            Button("Realm File") {
                databaseManager.printRealmFilePath()
            }
            .lineLimit(2)
        }
        .frame(height: 50)        
    }
}

struct DeveloperToolsView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperToolsView()
    }
}
