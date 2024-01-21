//
//  ShoppingListView.swift
//  ShoppingSorted
//
//  Created by Quinn on 28/09/2023.
//

import SwiftUI

struct ShoppingListView: View {
    
    @StateObject var vm = ShoppingListViewModel()
    
    var body: some View {
        ZStack {
            NavigationStack(path: $vm.navigationPath) {
                VStack {
                    List {
                        ForEach(vm.aislesList, id:\.self) { aisle in
                            ShoppingListDisclosureGroupView(vm: vm, aisle: aisle)
                        }
                        Section {
                            HStack {
                                Spacer()
                                Button("Show Recently Purchased") {
                                    vm.isShowingPurchasedItems = true
                                }
                                Spacer()
                            }
                        }
                    }
                }
                .blur(radius: (vm.isShowingExportView) ? 2 : 0)
                .onAppear {
                    vm.fetchItems()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Export", systemImage: "square.and.arrow.up") {
                            vm.isShowingExportView = true
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            vm.isAddingNewShoppingItem = true
                        } label: {
                            Label("Add Meal", systemImage: "plus")
                        }
                    }
                }
                .navigationTitle("Shopping List")
                .sheet(isPresented: $vm.isShowingPurchasedItems, onDismiss: {
                    vm.fetchItems()
                }, content: {
                    PurchasedItemsView()
                })
                .sheet(isPresented: $vm.isAddingNewShoppingItem, onDismiss: {
                    vm.fetchItems()
                }, content: {
                    PurchasableItemView(shoppingItem: nil)
                })
                .sheet(item: $vm.itemSelectedForEditing, onDismiss: {
                    vm.fetchItems()
                }, content: { item in
                    PurchasableItemView(shoppingItem: item)
                })
                .navigationDestination(for: ShoppingGroup.self, destination: { group in
                    GroupDetailView(group: group)
                })
            }
            .disabled(vm.isShowingExportView)
            if vm.isShowingExportView {
                ExportView(reminderStrings: vm.titlesForExportedReminders, isShowingExportView: $vm.isShowingExportView)
            }
        }
    }
}

#Preview {
    ShoppingListView()
}
