//
//  ContentView.swift
//  ShoppingSorted
//
//  Created by Quinn on 27/08/2023.
//

import SwiftUI

struct AppTabView: View {
    @State private var selection: Int = 1
    
    var body: some View {
        
        VStack {
            TabView(selection: $selection) {
                Group {
                    ShoppingListView()
                        .tabItem {
                            Label("Shopping List", systemImage: "list.bullet")
                        }
                        .tag(1)
                    MealsView()
                        .tabItem {
                            Label("Meals", systemImage: "fork.knife.circle")
                        }
                        .tag(2)
                }
                .toolbarBackground(.visible, for: .tabBar)
            }
            DeveloperToolsView()
        }
    }
}


struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}

