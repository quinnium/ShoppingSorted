//
//  ShoppingListDisclosureGroupView.swift
//  ShoppingSorted
//
//  Created by Quinn on 05/10/2023.
//

import SwiftUI

struct ShoppingListDisclosureGroupView: View {
    
    @ObservedObject var vm: ShoppingListViewModel
    @State var isExpanded: Bool = true
    var aisle: String
    
    var body: some View {
        Section {
            
            DisclosureGroup(isExpanded: $isExpanded) {
                if let shoppingGroupArray = vm.shoppingGroupsDict[aisle] {
                    ForEach(shoppingGroupArray) { group in
                        ShoppingGroupView(group: group, vm: vm)
                    }
                    .listRowInsets(.init(top: 5, leading: 0, bottom: 5, trailing: 5))
                    .listRowBackground(Color.systemBackground)
                }
            } label: {
                Text(aisle)
                    .bold()
                    .minimumScaleFactor(0.7)
            }
            .listRowBackground(Color(uiColor: .systemGray5))
        }
        .listSectionSpacing(10)
    }
}

#Preview {
    List {
        ShoppingListDisclosureGroupView(vm: ShoppingListViewModel(), aisle: "🍊 🥦 Fruit / Vegetables")
    }
}
