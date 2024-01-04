//
//  MealDetailNameView.swift
//  ShoppingSorted
//
//  Created by Quinn on 28/08/2023.
//

import SwiftUI

struct MealDetailNameView: View {
    // TODO: when clicked to edit name, if user launches a sheet, then editing ends but name not saved?
    @ObservedObject var vm: MealDetailViewModel
    @FocusState private var textFieldFocus: Bool
    
    var body: some View {
        VStack(spacing: 25) {
            HStack {
                TextField("Meal Name", text: $vm.mealName, axis: Axis.vertical)
                    .multilineTextAlignment(.leading)
                    .font(.title2)
                    .bold()
                    .lineLimit(3)
                    .focused($textFieldFocus)
                    .submitLabel(.done)
                
                Button {
                    if textFieldFocus {
                        vm.saveMealName()
                    }
                    textFieldFocus.toggle()
                    
                } label: {
                    if textFieldFocus {
                        Text("Save")
                            .padding(8)
                            .foregroundStyle(.green)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                    } else {
                        Text("Edit")
                            .padding(8)
                            .foregroundStyle(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                .padding(.horizontal, 8)
            }
        }
    }
}

struct MealDetailHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        MealDetailNameView(vm: .init(meal: RMMeal(name: "testMeal", ingredients: [])))
    }
}
