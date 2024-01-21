//
//  GroupItemView.swift
//  ShoppingSorted
//
//  Created by Quinn on 02/10/2023.
//

import SwiftUI

struct GroupItemView: View {
    let item: RMShoppingItem
    @ObservedObject var vm: GroupDetailViewModel
    @State private var isSelected: Bool = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Button {
                    isSelected.toggle()
                    if isSelected {
                        vm.itemMarkedAsPurchased(item: item)
                    } else {
                        vm.itemMarkedAsUnpurchased(item: item)
                    }
                } label: {
                    HStack {
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
                        ShoppingItemLabelView(name: item.name, quantity: item.quantity, unit: item.unit)
                    }
                }
                Button {
                    vm.itemSelectedForEditing = item
                } label: {
                    Label("", systemImage: "info.circle")
                        .foregroundStyle(Color.blue)
                        .imageScale(.large)
                }
                .buttonStyle(.plain)
                
            }
            if let forMealText = item.forMeal {
                Text("For '\(forMealText)'")
                    .italic()
                    .lineLimit(2)
                    .foregroundStyle(.gray)
                    .font(.caption)
                    .padding(.leading, 32)
            }
        }
        .padding(8)
        .padding(.horizontal, 8)
    }
}

#Preview {
    let item = RMShoppingItem(name: "Test", quantity: 100, unit: "ml", aisle: "aisle")
    return GroupItemView(item: item, vm: GroupDetailViewModel(group: ShoppingGroup(items: [item])!))
}
