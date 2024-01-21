//
//  MealDetail+AddToShoppingListOverlayView.swift
//  ShoppingSorted
//
//  Created by Quinn on 28/09/2023.
//

import SwiftUI

struct MealDetailAddToShoppingListOverlayView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: MealDetailViewModel
    @State private var animationStarted: Bool = false
    @State private var multiplier: Double = 1
    
    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .opacity(animationStarted ? 0.3 : 0)
                .animation(.linear(duration: 0.4), value: animationStarted)
            VStack {
                Text("Add All Ingedients To Shopping List?")
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .font(.title3)
                    .bold()
                    .frame(width: 250)
                HStack(spacing: 0) {
                    Text("Quantity multiplier")
                    Picker("Multiplier", selection: $multiplier) {
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
                HStack(spacing: 40) {
                    Button("Cancel") {
                        vm.isShowingAddToListCheck = false
                    }
                    .padding(10)
                    .frame(width: 100)
                    .foregroundStyle(.white)
                    .background(.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    Button("Add") {
                        vm.addIngredientsToShoppingList(multiplier: multiplier)
                        dismiss()
                    }
                    .padding(10)
                    .frame(width: 100)
                    .foregroundStyle(.white)
                    .background(.green)
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
    MealDetailAddToShoppingListOverlayView(vm: .init(meal: RMMeal(name: "", ingredients: [])))
}
