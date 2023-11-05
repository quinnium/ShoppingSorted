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
                            .frame(width: 24)
                        
                        if isSelected {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.green)
                                .frame(width: 18)
                        }
                    }
                }
                .buttonStyle(.plain)
                if isSingleShoppingItem {
                    Button {
                        vm.itemSelectedForEditing = group.shoppingItems.first
                    } label: {
                        HStack {
                            ShoppingItemLabelView(name: group.commonName, quantity: group.totalQuantity, unit: group.commonUnit)
                            Spacer()
                                .frame(width: 18.5)
                        }
                    }
                } else {
                    NavigationLink(value: group) {
                        ShoppingItemLabelView(name: group.commonName, quantity: group.totalQuantity, unit: group.commonUnit)
                    }
                    
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
        
        //        VStack(alignment: .leading) {
        //            HStack {
        //                Button {
        //                    isSelected.toggle()
        //                    if isSelected {
        //                        vm.itemsMarkedAsPurchased(items: group.shoppingItems)
        //                    } else {
        //                        vm.itemsMarkedAsUnpurchased(items: group.shoppingItems)
        //                    }
        //                } label: {
        //                    ZStack {
        //                        Circle()
        //                            .stroke(isSelected ? Color.green : Color.gray, lineWidth: 1)
        //                            .foregroundColor(.clear)
        //                            .frame(width: 24)
        //
        //                        if isSelected {
        //                            Image(systemName: "checkmark.circle.fill")
        //                                .resizable()
        //                                .scaledToFit()
        //                                .foregroundColor(.green)
        //                                .frame(width: 18)
        //                        }
        //                    }
        //                }
        //                .buttonStyle(.plain)
        //
        //                Text(group.commonName)
        //                    .lineLimit(1)
        //                    .minimumScaleFactor(0.6)
        //                Spacer()
        //                HStack {
        //                    Text(String(format: "%g", group.totalQuantity))
        //                    Text(group.commonUnit)
        //                }
        //                .frame(width: 100)
        //
        //                if !isSingleShoppingItem {
        //                    NavigationLink("", value: group)
        //                } else {
        //                    Button("") {
        //                        vm.itemSelectedForEditing = group.shoppingItems.first
        //                    }
        //                }
        //            }
        //            if isSingleShoppingItem {
        //                if let forMealText = group.shoppingItems.first?.forMeal {
        //                    Text("For: \(forMealText)")
        //                        .italic()
        //                        .foregroundStyle(.gray)
        //                        .font(.caption)
        //                        .padding(.leading, 32)
        //                }
        //            }
        //        }
    }
}

#Preview {
    let items = [
        ShoppingItem(name: "Olive Oil", quantity: 100.5, unit: "ml", aisle: "🍊 🥦 Fruit / Vegetables"),
        ShoppingItem(name: "Olive Oil", quantity: 10.6944, unit: "ml", aisle: "🍊 🥦 Fruit / Vegetables")
    ]
    let group = ShoppingGroup(items: items)!
    return List {
        DisclosureGroup("Test", isExpanded: .constant(true)) {
            ShoppingGroupView(group: group, vm: ShoppingListViewModel())
        }
    }
    
}
