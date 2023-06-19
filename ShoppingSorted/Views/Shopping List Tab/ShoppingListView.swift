//
//  ContentView.swift
//  ShoppingSorted
//
//  Created by Quinn on 08/03/2023.
//

import SwiftUI
import CoreData

struct ShoppingListView: View {
    
    // TODO: Can be deleted after testing
    @EnvironmentObject var badgeNotificationViewModel: BadgeNotificationViewModel
    
    @StateObject private var vm = ShoppingListViewModel()
    
    var body: some View {
        NavigationStack(path: $vm.path) {
            ZStack {
                VStack {
                    List {
                        ForEach(vm.aislesOrdered, id: \.self) { aisle in
                            Section(aisle) {
                                ForEach(vm.shoppingList[aisle]!) { group in
                                    ShoppingGroupView(group: group, vm: vm)
                                }
                            }
                        }
                        Button {
                            vm.deleteSheetDisplayed = true
                        } label: {
                            Text("Show Recently Purchased")
                        }
                    }
                    // Temp developer testing tools
                    HStack {
                        Text("Dev. test tools:")
                        Button("❌ items  ") {
                            vm.deleteAllShoppingItems()
                        }
                        Button("  ✅ Rand") {
                            vm.addRandomShoppingItem()
                            badgeNotificationViewModel.updateBadge(value: 1)
                        }
                    }
                    .padding(.bottom, 10)
                }
            }
            .navigationTitle("Shopping List")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        vm.isAddingIngredient = true
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .onAppear {
                vm.fetchAllItems()
            }
            .navigationDestination(for: GroupedIngredients.self, destination: { group in
                GroupDetailView(groupedIngredients: group)
            })
        }
        .sheet(isPresented: $vm.isAddingIngredient, onDismiss: {
            vm.fetchAllItems()
        }, content: {
            EditIngredientView(isAddingDirectlyToShoppingList: true, existingIngredient: nil, meal: nil)
        })
        
        .sheet(item: $vm.selectedIngredientToEdit, onDismiss: {
            vm.selectedIngredientToEdit = nil
            vm.fetchAllItems()
        }, content: { ingredient in
            EditIngredientView(isAddingDirectlyToShoppingList: true, existingIngredient: ingredient, meal: nil)
        })
        
        .sheet(isPresented: $vm.deleteSheetDisplayed,onDismiss: {
            vm.fetchAllItems()
        }) {
            PurchasedItemsView(deleteSheetDisplayed: $vm.deleteSheetDisplayed)
        }
    }
}



struct ShoppingListView_Previews: PreviewProvider {
    static var previews: some View {
        ShoppingListView()
    }
}
