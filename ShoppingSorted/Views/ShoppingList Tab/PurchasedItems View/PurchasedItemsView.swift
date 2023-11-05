//
//  PurchasedItemsView.swift
//  ShoppingSorted
//
//  Created by Quinn on 02/10/2023.
//

import SwiftUI

struct PurchasedItemsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var vm = PurchasedItemsViewModel()
    var body: some View {
        NavigationStack {
            List {
                ForEach(vm.purchasedItems) { item in
                    HStack {
                        Text(item.name)
                        Spacer()
                        HStack {
                            Text(String(format: "%g", item.quantity))
                            Text(item.unit)
                        }
                        .frame(width: 100)
                        Button("Undo") {
                            vm.unPurchase(item: item)
                        }
                    }
                }
            }
            .navigationTitle("Purchased")
            .navigationBarTitleDisplayMode(.large)
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Done")
                    }
                }
            })
        }
    }
}

#Preview {
    PurchasedItemsView()
}
