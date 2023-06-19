//
//  ShoppingSortedApp.swift
//  ShoppingSorted
//
//  Created by Quinn on 08/03/2023.
//

import SwiftUI

@main
struct ShoppingSortedApp: App {
    
    private let badgeNotificationViewModel = BadgeNotificationViewModel()
    
    var body: some Scene {
        WindowGroup {
            AppTabView()
                .environmentObject(badgeNotificationViewModel)
        }
    }
}
