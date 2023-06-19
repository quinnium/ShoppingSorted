//
//  GroupDetailView.swift
//  ShoppingSorted
//
//  Created by Quinn on 16/06/2023.
//

import SwiftUI

/*
 TODO: This view is largely a repeat of ShoppingGroupView, but both have different ViewModels as they are used on separate screens, each with bespoke functionality. They both need to be merged into a unified view in the future
 */

struct GroupDetailView: View {
    
    @StateObject var vm: GroupDetailViewModel
    
    init(groupedIngredients: GroupedIngredients) {
        _vm = StateObject(wrappedValue: GroupDetailViewModel(groupedIngredients: groupedIngredients))
    }
    
    
    var body: some View {
        HStack {
            List(vm.ingredients) { ingredient in
                HStack {
                    GroupDetailCircleButton(ingredient: ingredient, vm: vm)
                    
                    VStack {
                        HStack {
                            Text(ingredient.name ?? "")
                                .lineLimit(4)
                                .minimumScaleFactor(0.6)
                            Spacer()
                            HStack(spacing: 5) {
                                Group {
                                    Text(ingredient.quantityString)
                                    Text(ingredient.unit ?? "")
                                        .foregroundColor(.gray)
                                }
                                .lineLimit(1)
                                .minimumScaleFactor(0.6)
                            }
                            .frame(width: 90)
                        }
                        if ingredient.mealTagForShoppingList != nil {
                            HStack {
                                Text("For: \(ingredient.mealTagForShoppingList!)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .italic()
                                Spacer()
                            }
                            
                        }
                    }

                    Image(systemName: "info.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 22, alignment: .center)
                        .foregroundColor(.blue)
                        .onTapGesture {
                            vm.selectedIngredient = ingredient
                        }
                }
            }
        }
        .sheet(item: $vm.selectedIngredient) {
            // TODO: refresh items - not needed?
        } content: { ingredient in
            EditIngredientView(isAddingDirectlyToShoppingList: true, existingIngredient: ingredient, meal: nil)
        }
        
    }
}



struct GroupDetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView(groupedIngredients: GroupedIngredients(name: "Test", unit: "kg"))
    }
}



fileprivate struct GroupDetailCircleButton: View {
    
    @State var isSelected =  false
    let ingredient: Ingredient
    let vm: GroupDetailViewModel
    
    var body: some View {
        
        Button {
            isSelected.toggle()
            vm.purchaseIngredient(ingredient: ingredient, purchase: isSelected)
        } label: {
            ZStack {
                Circle()
                    .stroke(isSelected ? Color.green : Color.gray, lineWidth: 1)
                    .foregroundColor(.clear)
                    .frame(width: 24)
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.green)
                        .frame(width: 18)
                }
            }
        }
    }
}
