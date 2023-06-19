//
//  EditIngredientView.swift
//  ShoppingSorted
//
//  Created by Quinn on 25/03/2023.
//

import SwiftUI

enum TextFieldFocus { case name, quantity }

struct EditIngredientView: View {
    
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var badgeNotificationViewModel: BadgeNotificationViewModel
    @FocusState private var focusedTextField: TextFieldFocus?
    @StateObject private var vm: EditIngredientViewModel
    private var isSearching: Bool { (focusedTextField == .name && vm.itemName != "") }
    
    init(isAddingDirectlyToShoppingList: Bool, existingIngredient: Ingredient?, meal: Meal?) {
        _vm = StateObject(wrappedValue: EditIngredientViewModel(isAddingDirectlyToShoppingList: isAddingDirectlyToShoppingList, existingIngredient: existingIngredient, meal: meal))
        if existingIngredient == nil { focusedTextField = nil }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                
                // Item Name Row
                ItemNameView(itemName: $vm.itemName, focusedTextField: $focusedTextField)
                ZStack {
                    VStack(spacing: 15) {
                        
                        // Quantity & Unit
                        HStack {
                            QuantityView(itemQuantity: $vm.itemQuantity)
                                .focused($focusedTextField, equals: .quantity)
                            UnitView(units: vm.unitList, itemUnit: $vm.itemUnit)
                                .onTapGesture { focusedTextField = nil }
                            Spacer()
                        }
                        
                        // Aisle Picker
                        AislePickerView(aisles: vm.aisleList, itemAisle: $vm.itemAisle, isEditingAisles: $vm.isEditingDefaults, focusedTextField: $focusedTextField)
                        
                        // 'Add/Save' button
                        Button {
                            // If adding new ingredient to Shopping List
                            if vm.isAddingDirectlyToShoppingList && vm.existingIngredient == nil {
                                vm.addIngredientToShoppingList()
                                focusedTextField = nil
                                vm.resetForm()
                                badgeNotificationViewModel.updateBadge(value: 1)
                                print("saved to shopping list")
                            }
                            // If editing ingredient in Shopping List
                            else if vm.isAddingDirectlyToShoppingList && vm.existingIngredient != nil {
                                vm.updateExistingIngredient()
                            }
                            // If adding new ingredient to Meal
                            else if !vm.isAddingDirectlyToShoppingList && vm.existingIngredient == nil {
                                vm.addIngredientToMeal()
                            }
                            // If editing ingredient to Meal
                            else if !vm.isAddingDirectlyToShoppingList && vm.existingIngredient != nil {
                                vm.updateExistingIngredient()
                            }
                            dismiss()
                        } label: {
                            SSButton(title: vm.existingIngredient == nil ? "Add" : "Save", isEnabled: vm.isAllFieldsCompleted, color: .green, width: 100, height: 25)
                        }
                        .disabled(!vm.isAllFieldsCompleted)
                    }
                    .padding(.top, 10)
                    
                    // Search Results
                    if isSearching {
                        SearchResultsView(searchResults: vm.searchResults, vm: vm, focusedTextField: $focusedTextField)
                    }
                }
            }
            .padding()
            .navigationTitle(vm.navigationTitleText)
            .onAppear {
                if vm.itemName.isEmpty { focusedTextField = .name }
                vm.configurePreviousItemsDictionary()
            }
            .sheet(isPresented: $vm.isEditingDefaults) {
                self.vm.loadUnitsAndAisles()
            } content: {
                DefaultsListView(isEditingTypes: $vm.isEditingDefaults)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItemGroup(placement: .keyboard) {
                    Button {
                        focusedTextField = nil
                    } label: {
                        Label("Dismiss", systemImage: "keyboard.chevron.compact.down")
                    }
                    Spacer()
                    Button {
                        if focusedTextField == .name {
                            focusedTextField = .quantity
                        } else {
                            focusedTextField = nil
                        }
                    } label: {
                        if focusedTextField == .name {
                            Text("Next")
                                .bold()
                        } else {
                            Text("Done")
                                .bold()
                        }
                    }
                }
            }
        }
    }
}



struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        EditIngredientView(isAddingDirectlyToShoppingList: true, existingIngredient: nil, meal: nil)
    }
}



struct ItemNameView: View {
    
    @Binding var itemName: String
    var focusedTextField: FocusState<TextFieldFocus?>.Binding

    var body: some View {
        HStack(spacing: 15) {
            TextField("Item name", text: $itemName)
                .font(.system(size: 30, weight: .medium))
                .lineLimit(1)
                .minimumScaleFactor(0.3)
                .focused(focusedTextField, equals: .name)
                .onSubmit { focusedTextField.wrappedValue = .quantity }
                .submitLabel(.next)
                .padding(.vertical, 5)

            if focusedTextField.wrappedValue == .name && itemName != "" {
                Button {
                    itemName = ""
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.gray)
                }
                .frame(width: 15, height: 15)
                
            }
        }
        .padding(.horizontal, 15)
        .ssRoundedRectangle(color: .gray, width: 1, cornerRadius: 8)
    }
}



struct QuantityView: View {
    
    @Binding var itemQuantity: Double
    private let quantityFormatter: NumberFormatter = {
        let formatter           = NumberFormatter()
        formatter.locale        = Locale.current
        formatter.numberStyle   = .decimal
        formatter.zeroSymbol    = ""
        return formatter
    }()
    
    var body: some View {
        HStack {
            // Quantity field
            TextField("Quantity", value: $itemQuantity, formatter: quantityFormatter)
                .frame(width: 100, height: 40)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .ssRoundedRectangle(color: .gray, width: 1, cornerRadius: 8)
        }
    }
}



struct UnitView: View {
    
    let units: [String]
    @Binding var itemUnit: String
    
    var body: some View {
        Picker("", selection: $itemUnit) {
            ForEach(units, id: \.self) { unit in
                Text(unit)
            }
        }
        .fixedSize()
        .pickerStyle(.menu)
        .frame(height: 40)
        .ssRoundedRectangle(color: .gray, width: 1, cornerRadius: 8)
    }
}



struct AislePickerView: View {
    
    let aisles: [String]
    @Binding var itemAisle: String?
    @Binding var isEditingAisles: Bool
    var focusedTextField: FocusState<TextFieldFocus?>.Binding
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text("Aisle")
                    .foregroundColor(.gray)
                    .fontWeight(.light)
                Spacer()
                Button {
                    focusedTextField.wrappedValue = nil
                    isEditingAisles = true
                } label: {
                    Text("Edit Units / Aisles")
                        .font(Font.footnote)
                }
            }
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(aisles, id:\.self) { aisle in
                        ZStack {
                            Rectangle()
                                .border(.black, width: 0.5)
                                .foregroundColor(aisle == itemAisle ? .blue : .white)
                                .opacity(0.1)
                            HStack {
                                Text(aisle)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                                    .padding(.horizontal)
                                Spacer()
                                if aisle == itemAisle {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                        .padding(.horizontal)
                                }
                            }
                        }
                        .frame(height: 40)
                        .onTapGesture {
                            focusedTextField.wrappedValue = nil
                            itemAisle = aisle
                        }
                    }
                }
            }
            .ssRoundedRectangle(color: .gray, width: 1, cornerRadius: 8)
        }
    }
}



struct SearchResultsView: View {
    
    var searchResults: [String]
    @ObservedObject var vm: EditIngredientViewModel
    var focusedTextField: FocusState<TextFieldFocus?>.Binding
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(searchResults.count > 0 ? Color(uiColor: .systemBackground) : .clear)
            if searchResults.count > 0 {
                List(searchResults, id:\.self) { item in
                    Button(item) {
                        if vm.previousItemsDictionary[item] != nil {
                            vm.configureForExistingIngredient(ingredient: vm.previousItemsDictionary[item]!, includeQuantity: false)
                        }
                        focusedTextField.wrappedValue = .quantity
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}
