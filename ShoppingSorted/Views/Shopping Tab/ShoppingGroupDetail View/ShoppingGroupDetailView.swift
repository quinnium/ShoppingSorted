//
//  ShoppingGroupDetailView.swift
//  ShoppingSorted
//
//  Created by Quinn on 17/09/2023.
//

import SwiftUI

struct ShoppingGroupDetailView: View {
    
    @StateObject var vm: ShoppingGroupDetailViewModel
    
    init(group: ShoppingGroup) {
        _vm = StateObject(wrappedValue: ShoppingGroupDetailViewModel(group: group))
    }
    
    var body: some View {
        ForEach(vm.group.items) { item in
                // ShoppingGroupView(group: ShoppingGroup(items: [item])!, vm: vm)
        }
        Spacer()
    }
}


struct ShoppingGroupDetailView_Previews: PreviewProvider {
    static let items: [ShoppingItem] = [
        ShoppingItem(name: "Test", quantity: 2.5, unit: "ml", aisle: "aisleTest"),
        ShoppingItem(name: "Test", quantity: 2.5, unit: "ml", aisle: "aisleTest")
    ]
    static var previews: some View {
        ShoppingGroupDetailView(group: ShoppingGroup(items: items)!)
    }
}
