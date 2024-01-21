//
//  PurchasableItemView.swift
//  ShoppingSorted
//
//  Created by Quinn on 01/09/2023.
//

import SwiftUI



struct PurchasableItemView: View {
    
    enum TextFieldFocus { case name, quantity }
    
    @Environment(\.dismiss) var dismiss
    @FocusState  var focusedTextField: TextFieldFocus?
    @StateObject var vm: PurchasableItemViewModel
    
    
    // Init for when adding/editing a ShoppingItem
    init(shoppingItem: RMShoppingItem?) {
        _vm = StateObject(wrappedValue: PurchasableItemViewModel(shoppingItem: shoppingItem))
    }
    
    // Init for when adding/editing an Ingredient
    init(ingredient: RMIngredient?, parentMeal: RMMeal) {
        _vm = StateObject(wrappedValue: PurchasableItemViewModel(ingredient: ingredient, parentMeal: parentMeal))
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                PurchasableItemNameView(itemName: $vm.itemName, textFieldFocus: $focusedTextField)
                ZStack {
                    VStack {
                        HStack() {
                            PurchasableItemQuantityView(itemQuantity: $vm.itemQuantity, focusedTextField: $focusedTextField)
                            PurchasableItemUnitView(units: vm.unitList, itemUnit: $vm.itemUnit, focusedTextField: $focusedTextField)
                            Spacer()
                            Button {
                                focusedTextField = .none
                                vm.isEditingUnitsAndAisles = true
                            } label: {
                                Text("Edit Units / Aisles")
                                    .font(Font.footnote)
                            }
                            .frame(height: 35, alignment: .bottom)
                        }
                        PurchasableItemAisleView(aisles: vm.aisleList, itemAisle: $vm.itemAisle, focusedTextField: $focusedTextField)
                    }
                    if focusedTextField == .name && vm.itemName.isNotEmpty && vm.searchresults.isNotEmpty {
                        List(vm.searchresults, id: \.self) { name in
                            Button(name.firstUppercased) {
                                vm.previousItemSelected(name: name)
                                focusedTextField = .quantity
                            }
                        }
                        .listStyle(.plain)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.systemBackground)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(vm.addOrSaveButtonTitle) {
                        vm.primaryActionButtonPressed()
                        dismiss()
                    }
                    .bold()
                    .disabled(!vm.isValidToSave)
                }
            }
            .padding()
            .navigationTitle(vm.title)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $vm.isEditingUnitsAndAisles) {
                vm.loadUnitsAndAisles()
            } content: {
                EditUnitsAndAislesView()
            }
            .onAppear {
                if vm.immediateFocusOnNameField {
                    focusedTextField = .name
                }
            }
        }
        // TODO: Ensure keyboard buttons etc functions as per old app, as UX important on this screen
        .alert("Invalid Aisle", isPresented: $vm.isShowingAlertInvalidAisle, actions: {
            Button("OK") { }
        }, message: {
            Text("This item's Aisle (\(vm.oldInvalidAisleName ?? "")) no longer matches any of those from the current options. You will need to either select a new Aisle for this item, edit the Aisle options, or tap Cancel to revert back")
        })
        .alert("Unit Changed", isPresented: $vm.isShowingAlertInvalidUnit, actions: {
            Button("OK") { }
        }, message: {
            Text("This item's Unit type ('\(vm.oldInvalidUnitName ?? "")') no longer matches any of those from the current options. A default unit of '\(vm.itemUnit)' has been selected instead. Please check the unit type, edit the Unit options, or tap Cancel to revert back")
        })
    }
}

struct PurchasableItemView_Previews: PreviewProvider {
    static var previews: some View {
        PurchasableItemView(ingredient: RMIngredient(name: "Test Ing", quantity: 1, unit: "noone", aisle: "🥩 🍗 Meat"), parentMeal: RMMeal(name: "Yest", ingredients: []))
    }
}
