//
//  AllMealsView.swift
//  ShoppingSorted
//
//  Created by Quinn on 25/03/2023.
//

import SwiftUI

struct AllMealsView: View {
    
    @StateObject private var vm     = AllMealsShoppingListViewModel()
    @State private var path: [Meal] = []
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                VStack(spacing: 10) {
                    List(vm.meals) { meal in
                        NavigationLink(value: meal) {
                            VStack(alignment: .leading) {
                                Text(meal.name ?? "-")
                                    .bold()
                                Text("Ingredients: \(meal.ingredients?.count.description ?? "-")")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                if vm.isShowingAddMealOverlay {
                    AddMealViewOverlay(vm: vm, path: $path)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        vm.isShowingAddMealOverlay = true
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            Spacer()
            // Temp developer testing tools
            HStack(spacing: 10) {
                Text("Dev. test tools:")
                Button("❌ Meals  ") {
                    vm.deleteAllMeals()
                }
                Button("  ✅ Rand") {
                    vm.addRandomMeal()
                }
            }
            .navigationDestination(for: Meal.self, destination: { meal in
                MealDetailView(meal: meal)
            })
            .navigationTitle("Meals")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                print("MealsView Appeared!")
                vm.loadMeals()
            }
        }
    }
}



struct MealsView_Previews: PreviewProvider {
    static var previews: some View {
        AllMealsView()
    }
}



struct AddMealViewOverlay: View {
    
    @ObservedObject var vm: AllMealsShoppingListViewModel
    @FocusState var isTextFieldFocused: Bool
    @Binding var path: [Meal]
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.black)
                .ignoresSafeArea()
                .opacity(0.2)
            VStack(spacing: 20) {
                Text("Add Meal")
                    .multilineTextAlignment(.center)
                    .bold()
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                    .frame(width: 240)
                TextField("Meal name", text: $vm.addMealName, axis: .vertical)
                    .lineLimit(5)
                    .frame(width: 250)
                    .focused($isTextFieldFocused)
                    .onAppear {
                        vm.addMealName      = ""
                        isTextFieldFocused  = true
                    }
                HStack {
                    Button {
                        vm.isShowingAddMealOverlay = false
                    } label: {
                        SSButton(title: "Cancel", isEnabled: true, color: .gray, width: 75, height: 30)
                    }
                    Button {
                        vm.isShowingAddMealOverlay = false
                        path.append(vm.addNewMeal())
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
