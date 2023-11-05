//
//  MealSelectionOptionsView.swift
//  ShoppingSorted
//
//  Created by Quinn on 07/10/2023.
//

import SwiftUI

struct MealSelectionOptionsView: View {
    
    @ObservedObject var vm: MealsViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .foregroundStyle(Color(uiColor: .systemGray3))
                .frame(height: 1)
            HStack {
                Spacer()
                Button {
                    vm.deleteSelectedMeals()
                } label: {
                    Label("Delete", systemImage: "trash")
                }
                .disabled(vm.selectedMeals.isEmpty)
                Spacer()
                Button {
                    vm.didTapExport()
                } label: {
                    Label("Export", systemImage: "square.and.arrow.up")
                }
                .disabled(vm.selectedMeals.isEmpty)
                Spacer()
            }
            .padding(.vertical, 15)
            .background(Color(uiColor: .systemBackground))
        }
    }
}

#Preview {
    MealSelectionOptionsView(vm: MealsViewModel())
}
