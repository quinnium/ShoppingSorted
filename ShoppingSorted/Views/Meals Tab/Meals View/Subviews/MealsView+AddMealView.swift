//
//  MealsView+AddMealView.swift
//  ShoppingSorted
//
//  Created by Quinn on 26/09/2023.
//

import SwiftUI

struct MealsViewAddMealView: View {
    @ObservedObject var vm: MealsViewModel
    @State private var animationStarted: Bool = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .opacity(animationStarted ? 0.3 : 0)
                .animation(.linear(duration: 0.4), value: animationStarted)
            VStack {
                Text("Add new meal")
                    .font(.title2)
                    .bold()
                TextField("Name", text: $vm.newMealName, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(3)
                    .padding()
                    .focused($isFocused)
                HStack(spacing: 40) {
                    Button("Cancel") {
                        isFocused = false
                        vm.isAddingMeal = false
                    }
                    .padding(10)
                    .frame(width: 100)
                    .foregroundStyle(.white)
                    .background(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    Button("Add") {
                        isFocused = false
                        vm.addNewmeal()
                        vm.isAddingMeal = false
                    }
                    .padding(10)
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.white)
                    .background(.green)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding()
            .background(Color.systemBackground)
            .ssRoundedRectangle(color: .dynamicBlack, width: 2, cornerRadius: 20)
            .ssRoundedRectangle(color: .dynamicWhite, width: 0.5, cornerRadius: 20)
            .padding()
            .offset(x: animationStarted ? 0 : 1000)
            .animation(.easeOut(duration: 0.4), value: animationStarted)
        }
        .onAppear {
            animationStarted = true
            isFocused = true
        }
        
    }
}

#Preview {
    MealsViewAddMealView(vm: .init())
}
