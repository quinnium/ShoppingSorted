//
//  ShoppingSortedApp.swift
//  ShoppingSorted
//
//  Created by Quinn on 27/08/2023.
//

import SwiftUI

@main
struct ShoppingSortedApp: App {
    
    let migrationManager = MigrationManager()
    
    var body: some Scene {
        WindowGroup {
            AppTabView()
                .onAppear(perform: {
                    migrationManager.convertCoreDataObjectsInMemory()
                })
        }
    }
}
