//
//  PurchasedItemsView.swift
//  ShoppingSorted
//
//  Created by Quinn on 24/03/2023.
//

import SwiftUI

struct PurchasedItemsView: View {
    
    @StateObject private var vm = PurchasedItemsViewModel()
    @Binding var deleteSheetDisplayed: Bool
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.itemsPurchased) { group in
                    
                    HStack(spacing: 10) {
                        Text(group.name)
                            .lineLimit(3)
                            .minimumScaleFactor(0.6)
                        Spacer()
                        HStack(spacing: 5) {
                            Group {
                                Text(group.quantityString)
                                + Text(" ")
                                + Text(group.unit)
                                    .foregroundColor(.gray)
                            }
                            .lineLimit(1)
                            .minimumScaleFactor(0.6)
                            
                        }
                        .frame(width: 90)

                        Text("Undo")
                            .foregroundColor(.blue)
                            .onTapGesture {
                                vm.undoPurchase(groupItem: group)
                            }
                    }
                }
            }
            .navigationTitle("Recently purchased")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button("Done") {
                        deleteSheetDisplayed = false
                    }
                }
            }
        }
    }
}



struct DeletedItems_Previews: PreviewProvider {
    static var previews: some View {
        PurchasedItemsView(deleteSheetDisplayed: .constant(true))
    }
}
