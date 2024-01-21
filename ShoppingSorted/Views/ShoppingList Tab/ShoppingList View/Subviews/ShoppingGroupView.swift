//
//  ShoppingGroupView.swift
//  ShoppingSorted
//
//  Created by Quinn on 29/09/2023.
//

import SwiftUI

struct ShoppingGroupView: View {
    
    let group: ShoppingGroup
    @ObservedObject var vm: ShoppingListViewModel
    @State var isSelected: Bool = false
    private var isSingleShoppingItem: Bool {
        group.shoppingItems.count == 1
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Button {
                    isSelected.toggle()
                    if isSelected {
                        vm.itemsMarkedAsPurchased(items: group.shoppingItems)
                    } else {
                        vm.itemsMarkedAsUnpurchased(items: group.shoppingItems)
                    }
                } label: {
                    ZStack {
                        Circle()
                            .stroke(isSelected ? Color.green : Color.gray, lineWidth: 1)
                            .foregroundColor(.clear)
                            .frame(width: 22)
                        
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.green)
                                .frame(width: 16)
                        }
                    }
                }
                .offset(x: -5, y: 0)

                ShoppingItemLabelView(name: group.commonName, quantity: group.totalQuantity, unit: group.commonUnit)
                Spacer()
                    .frame(width: 18.5)
                
                if isSingleShoppingItem {
                    Button {
                        print("tapped1")
                        vm.itemSelectedForEditing = group.shoppingItems.first
                    } label: {
                        Label("", systemImage: "info.circle")
                    }
                    .buttonStyle(.plain)
                    .frame(width: 20)
                } else {
                    Button {
                        print("tapped1")
                        vm.navigationPath.append(group)
                    } label: {
                        Label("", systemImage: "chevron.right.circle")
                    }
                    .buttonStyle(.plain)
                    .frame(width: 20)
                }
            }
            
            if isSingleShoppingItem, let forMealText = group.shoppingItems.first?.forMeal {
                Text("For '\(forMealText)'")
                    .italic()
                    .lineLimit(2)
                    .foregroundStyle(.gray)
                    .font(.caption)
                    .padding(.leading, 32)
            }
        }
    }
}

#Preview {
    let items = [
        RMShoppingItem(name: "Olive Oil", quantity: 100.5, unit: "ml", aisle: "🍊 🥦 Fruit / Vegetables")
        ,RMShoppingItem(name: "Olive Oil", quantity: 10.6944, unit: "ml", aisle: "🍊 🥦 Fruit / Vegetables")
    ]
    let group = ShoppingGroup(items: items)!
    return List {
        DisclosureGroup("Test Aisle", isExpanded: .constant(true)) {
            ShoppingGroupView(group: group, vm: ShoppingListViewModel())
        }
    }
    
}
