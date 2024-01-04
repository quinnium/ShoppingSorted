//
//  GroupDetailView.swift
//  ShoppingSorted
//
//  Created by Quinn on 02/10/2023.
//

import SwiftUI

struct GroupDetailView: View {
    
    @StateObject var vm: GroupDetailViewModel
    
    init(group: ShoppingGroup) {
        _vm = StateObject(wrappedValue: GroupDetailViewModel(group: group))
    }
    
    var body: some View {
        ScrollView {
            ForEach(vm.shoppingItems) { item in
                GroupItemView(item: item, vm: vm)
            }
        }
        .sheet(item: $vm.itemSelectedForEditing) {
            vm.fetchItems()
        } content: { item in
            PurchasableItemView(shoppingItem: item)
        }

    }
}

#Preview {
    let items: [RMShoppingItem] = []
    return GroupDetailView(group: ShoppingGroup(items: items)!)
}
