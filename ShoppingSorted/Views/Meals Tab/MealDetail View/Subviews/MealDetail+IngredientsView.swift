//
//  MealDetailIngredientsView.swift
//  ShoppingSorted
//
//  Created by Quinn on 28/08/2023.
//

import SwiftUI

struct MealDetailIngredientsView: View {
    
    @ObservedObject var vm: MealDetailViewModel
    
    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Ingredients")
                        .font(.title2.weight(.light))
                        .foregroundColor(Color(uiColor: .systemGray2))
                }
                Spacer()
                Button {
                    vm.isAddingIngredient = true
                } label: {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
            }
            List() {
                ForEach($vm.ingredientsList) { item in
                    if let ingredient = vm.getIngredient(id: item.wrappedValue.id) {
                        Button {
                            vm.selectedIngredient = ingredient
                        } label: {
                            HStack {
                                Text(ingredient.name)
                                Spacer()
                                Text(ingredient.quantity.description)
                                Text(ingredient.unit)
                            }
                        }
                    }
                    
                }
                .onDelete { indexSet in
                    vm.deleteIngredient(at: indexSet)
                }
            }
            .listStyle(.plain)
            .listRowSeparator(.automatic)
        }
        .padding()
        .ssRoundedRectangle(color: .gray, width: 1, cornerRadius: 10)
        .sheet(isPresented: $vm.isAddingIngredient, onDismiss: {
            vm.fetchIngredients()
        }, content: {
            PurchasableItemView(ingredient: nil, parentMeal: vm.meal)
        })
        .sheet(item: $vm.selectedIngredient) {
            vm.fetchIngredients()
        } content: { ingredient in
            PurchasableItemView(ingredient: ingredient, parentMeal: vm.meal)
        }

    }
}

struct MealDetailIngredientsView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailIngredientsView(vm: .init(meal: RMMeal(name: "TestMeal", ingredients: [])))
    }
}
