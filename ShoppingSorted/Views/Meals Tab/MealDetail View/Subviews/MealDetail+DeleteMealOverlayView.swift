//
//  MealDetail+DeleteMealOverlayView.swift
//  ShoppingSorted
//
//  Created by Quinn on 28/09/2023.
//

import SwiftUI

struct MealDetailDeleteMealOverlayView: View {
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: MealDetailViewModel
    @State private var animationStarted: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .opacity(animationStarted ? 0.3 : 0)
                .animation(.linear(duration: 0.4), value: animationStarted)
            VStack {
                Text("Delete Meal?")
                    .font(.title3)
                    .bold()
                HStack(spacing: 40) {
                    Button("Cancel") {
                        vm.isShowingDeleteMealCheck = false
                    }
                    .padding(10)
                    .frame(width: 100)
                    .foregroundStyle(.white)
                    .background(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    Button("Delete") {
                        vm.deleteMeal()
                        dismiss()
                    }
                    
                    .padding(10)
                    .frame(width: 100)
                    .foregroundStyle(.white)
                    .background(.red)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .padding(.horizontal)
                .padding(.top, 5)
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
        }
    }
}

#Preview {
    MealDetailDeleteMealOverlayView(vm: MealDetailViewModel(meal: Meal(name: "Test", ingredients: [])))
}
