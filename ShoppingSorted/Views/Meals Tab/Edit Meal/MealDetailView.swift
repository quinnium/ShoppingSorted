//
//  MealDetailView.swift
//  ShoppingSorted
//
//  Created by AQ on 06/04/2023.
//

import SwiftUI

// Only one case doe now, but structured like this for potential future other FocusState options
enum MealDetailViewFocus { case name }

struct MealDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @FocusState var focusState: MealDetailViewFocus?
    @StateObject private var vm: MealDetailViewModel
    // These two state items cannot be inside ViewModel, to avoid disappearing SwiftUI sheet bug
    @State private var isEditingIngredient = false
    @State private var selectedIngredient: Ingredient?
    
    init(meal: Meal?) {
        _vm = StateObject(wrappedValue: MealDetailViewModel(meal: meal))
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                        .frame(width: 20)
                    TextField("Meal Name", text: $vm.mealName, axis: .vertical)
                        .multilineTextAlignment(.center)
                        .font(.title2)
                        .bold()
                        .lineLimit(3)
                        .focused($focusState, equals: .name)
                        .submitLabel(.done)
                        .onSubmit { vm.saveName() }
                    Button {
                        if focusState == .name {
                            focusState = nil
                            vm.saveName()
                        } else {
                            focusState = .name
                        }
                    } label: {
                        if focusState == .name {
                            Image(systemName: "checkmark.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.green)
                        } else {
                            Image(systemName: "pencil")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.blue)
                        }
                    }
                    .frame(width: 20)
                }
                .padding(.vertical, 15)
 
                VStack {
                    HStack {
                        Text("Ingredients")
                            .font(.title2.weight(.light))
                            .foregroundColor(Color(uiColor: .systemGray3))
                        Spacer()
                        Button {
                            selectedIngredient = nil
                            isEditingIngredient.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }
                    
                    List() {
                        ForEach(vm.ingredients) { ingredient in
                            Button {
                                selectedIngredient = ingredient
                                isEditingIngredient = true
                            } label: {
                                HStack {
                                    Text(ingredient.name ?? "nil")
                                        
                                    Spacer()
                                    Text(ingredient.quantity.description)
                                    Text(ingredient.unit ?? "nil")
                                }

                            }
                            .padding(.vertical, 5)
                        }
                        .onDelete { indexSet in
                            vm.swipeToDeleteAction(at: indexSet)
                        }
                    }
                    .listStyle(.plain)
                    .listRowSeparator(.automatic)
                }
                .padding()
                .ssRoundedRectangle(color: .gray, width: 1, cornerRadius: 10)
                
                HStack {
                    Button {
                        vm.isShowingDeleteMealCheck = true
                    } label: {
                        SSButton(title: "Delete Meal", isEnabled: (vm.meal != nil), color: .red, bordered: true, width: 150, height: 20)
                    }
                    
                    Button {
                        vm.isShowingAddMealCheck = true
                    } label: {
                        SSButton(title: "Add To List", isEnabled: (vm.meal?.ingredients?.count ?? 0 > 0), color: .green, width: 150, height: 20)
                    }
                }
                .padding(.vertical)
            }
            .padding(.horizontal, 20)
            .sheet(isPresented: $isEditingIngredient) {
                isEditingIngredient = false
                vm.loadIngredients()
            } content: {
                EditIngredientView(isAddingDirectlyToShoppingList: false, existingIngredient: selectedIngredient, meal: vm.meal)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .blur(radius: (vm.isShowingAddMealCheck || vm.isShowingDeleteMealCheck) ? 2 : 0)
            
            if vm.isShowingAddMealCheck {
                AddMealToListOverlay(vm: vm)
            }
            
            if vm.isShowingDeleteMealCheck {
                DeleteMealCheckOverlay(vm: vm)
            }
        }
        .onAppear { print("EditMeal View apeared") }
        .onChange(of: vm.dismissView) { _ in
            dismiss()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}



struct EditMealView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView(meal: nil)
    }
}



struct AddMealToListOverlay: View {
    @EnvironmentObject var badgeNotificationViewModel: BadgeNotificationViewModel
    @ObservedObject var vm: MealDetailViewModel
    @State private var selection: Double = 1
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
                .opacity(0.2)
            VStack(spacing: 20) {
                Text("Add All Ingredients To Shopping List?")
                    .multilineTextAlignment(.center)
                    .bold()
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .frame(width: 240)
                HStack(spacing: 0) {
                    Text("Multiplier")
                    Picker("Multiplier", selection: $selection) {
                        Text("x ¼").tag(Double(0.25))
                        Text("x ⅓").tag(Double(0.333))
                        Text("x ½").tag(Double(0.5))
                        Text("x 1").tag(Double(1))
                        Text("x 2").tag(Double(2))
                        Text("x 3").tag(Double(3))
                        Text("x 4").tag(Double(4))
                        Text("x 5").tag(Double(5))
                    }
                    .pickerStyle(.menu)
                    .frame(width: 80)
                }
                HStack {
                    Button {
                        vm.isShowingAddMealCheck = false
                    } label: {
                        SSButton(title: "Cancel", isEnabled: true, color: .gray, width: 75, height: 30)
                    }
                    Button {
                        vm.addIngredientsToShoppingList(multiplier: selection)
                        vm.isShowingAddMealCheck = false
                        vm.dismissView = true
                        badgeNotificationViewModel.updateBadge(value: vm.meal?.ingredients?.count ?? 0)
                    } label: {
                        SSButton(title: "Add", isEnabled: true, color: .green, width: 75, height: 30)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .ssRoundedRectangle(color: .black, width: 2, cornerRadius: 20)
        }
    }
}



struct DeleteMealCheckOverlay: View {
    
    @ObservedObject var vm: MealDetailViewModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
                .opacity(0.2)
            VStack(spacing: 20) {
                Text("Delete Meal?")
                    .multilineTextAlignment(.center)
                    .bold()
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .frame(width: 240)
                HStack {
                    Button {
                        vm.isShowingDeleteMealCheck = false
                    } label: {
                        SSButton(title: "Cancel", isEnabled: true, color: .gray, width: 75, height: 30)
                    }
                    Button {
                        vm.deleteMeal()
                        vm.isShowingDeleteMealCheck = false
                        vm.dismissView = true
                    } label: {
                        SSButton(title: "Delete", isEnabled: true, color: .red, width: 75, height: 30)
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .ssRoundedRectangle(color: .black, width: 2, cornerRadius: 20)
        }
    }
}
