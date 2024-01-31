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
                    // Migration service in case of legacy users needing to convert Core Data -> Realm
                    migrationManager.convertCoreDataObjectsInMemory()
                })
        }
    }
}
