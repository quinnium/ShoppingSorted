//
//  ShoppingGroupView.swift
//  ShoppingSorted
//
//  Created by Quinn on 09/09/2023.
//

import SwiftUI

struct ShoppingGroupView: View {
    
    let group: ShoppingGroup
    let actionOnCheck: () -> Void
    let actionOnUncheck: () -> Void
    @State private var selectedItemForEditing: ShoppingItem?

    @State private var isSelected: Bool = false
    
    var body: some View {
        HStack {
            RadialButtonView(isSelected: isSelected)
                .onTapGesture {
                    isSelected.toggle()
                    if isSelected {
                        actionOnCheck()
                    } else {
                        actionOnUncheck()
                    }
                }
            Text(group.commonName)
            Spacer()
            Text(group.totalQuantity.description)
            Text(group.commonUnit)
            
            if group.items.count == 1 {
                Image(systemName: "info.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 22, alignment: .center)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        selectedItemForEditing = group.items.first
                    }
            }
            else if group.items.count > 1 {
                NavigationLink {
                    ShoppingGroupDetailView(group: group)
                } label: {
                    Image(systemName: "chevron.right.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 22, alignment: .center)
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 3)
        .sheet(item: $selectedItemForEditing) {
            // on dismiss
        } content: { item in
            PurchasableItemView(shoppingItem: item)
        }

    }
}

struct ShoppingGroupView_Previews: PreviewProvider {
    static let items: [ShoppingItem] = [
        ShoppingItem(name: "Test", quantity: 2.5, unit: "ml", aisle: "aisleTest"),
        ShoppingItem(name: "Test", quantity: 2.5, unit: "ml", aisle: "aisleTest")
    ]
    static var previews: some View {
        ShoppingGroupView(group: ShoppingGroup(items: items)!, actionOnCheck: {}, actionOnUncheck: {})
    }
}
