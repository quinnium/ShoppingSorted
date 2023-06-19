//
//  AppTabView.swift
//  ShoppingSorted
//
//  Created by Quinn on 25/03/2023.
//

import SwiftUI

struct AppTabView: View {
    
    @State private var selection: Int = 1
    
    var body: some View {
        TabView(selection: $selection) {
            ShoppingListView()
                .tabItem {
                    Label("Shopping List", systemImage: "list.bullet")
                }
                .tag(1)
            
            AllMealsView()
                .tabItem {
                    Label("Meals", systemImage: "fork.knife.circle")
                }
                .tag(2)
        }
        .overlay(BadgeNotificationView(), alignment: .bottomLeading)
    }
}


struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}


