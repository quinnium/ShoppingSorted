//
//  MealDetailView.swift
//  ShoppingSorted
//
//  Created by Quinn on 28/08/2023.
//

import SwiftUI

struct MealDetailView: View {

    @Environment(\.dismiss) var dismiss
    @StateObject var vm: MealDetailViewModel
    
    init(meal: Meal) {
        _vm = StateObject(wrappedValue: MealDetailViewModel(meal: meal))
    }
    
    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                MealDetailNameView(vm: vm)
                MealDetailIngredientsView(vm: vm)
                MealDetailFooterView(vm: vm)
            }
            .padding(15)
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .blur(radius: (vm.isShowingAddToListCheck || vm.isShowingDeleteMealCheck) ? 2 : 0)
            
            if vm.isShowingAddToListCheck {
                MealDetailAddToShoppingListOverlayView(vm: vm)
            }
            
            if vm.isShowingDeleteMealCheck {
                MealDetailDeleteMealOverlayView(vm: vm)
            }
        }
        .navigationBarTitleDisplayMode(.inline)


    }
}

struct MealDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailView(meal: Meal(name: "testmeal", ingredients: []))
    }
}
