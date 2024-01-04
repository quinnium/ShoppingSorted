//
//  MealDetailFooterView.swift
//  ShoppingSorted
//
//  Created by Quinn on 28/08/2023.
//

import SwiftUI

struct MealDetailFooterView: View {
    
    @ObservedObject var vm: MealDetailViewModel
    
    var body: some View {
        HStack(spacing: 40) {
            Button {
                vm.isShowingDeleteMealCheck = true
            } label: {
                Text("Delete Meal")
                    .foregroundStyle(.red)
                    .frame(width: 150, height: 40)
                    .ssRoundedRectangle(color: .red, width: 2, cornerRadius: 10)
            }
            
            Button {
                vm.isShowingAddToListCheck = true
            } label: {
                Text("Add To List")
                    .foregroundStyle(vm.ingredientsList.isEmpty ? .gray : .green)
                .frame(width: 150, height: 40)
                .ssRoundedRectangle(color: vm.ingredientsList.isEmpty ? .gray : .green, width: 2, cornerRadius: 10)
            }
            .disabled(vm.ingredientsList.isEmpty)
        }
    }
}

struct MealDetailFooterView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailFooterView(vm: .init(meal: RMMeal(name: "Test Meal", ingredients: [])))
    }
}
