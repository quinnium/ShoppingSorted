//
//  PurchasableItem+AisleView.swift
//  ShoppingSorted
//
//  Created by Quinn on 02/09/2023.
//

import SwiftUI

struct PurchasableItemAisleView: View {

    let aisles: [String]
    @Binding var itemAisle: String
    var focusedTextField: FocusState<TextFieldFocus?>.Binding
    
    var body: some View {
        VStack(spacing: 5) {
            HStack {
                Text("Aisle")
                    .foregroundColor(.gray)
                    .fontWeight(.light)
                Spacer()
            }
            ScrollViewReader { scrollproxy in
                ScrollView {
                        VStack(spacing: 0) {
                            ForEach(aisles, id:\.self) { aisle in
                                ZStack {
                                    Rectangle()
                                        .border(.black, width: 0.5)
                                        .foregroundColor(aisle == itemAisle ? .blue : .white)
                                        .opacity(0.1)
                                    HStack {
                                        Text(aisle)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.5)
                                            .padding(.horizontal)
                                        Spacer()
                                        if aisle == itemAisle {
                                            Image(systemName: "checkmark")
                                                .foregroundColor(.blue)
                                                .padding(.horizontal)
                                        }
                                    }
                                }
                                .frame(height: 40)
                                .onTapGesture {
                                    focusedTextField.wrappedValue = nil
                                    itemAisle = aisle
                                }
                                .simultaneousGesture(DragGesture().onChanged({ _ in
                                    focusedTextField.wrappedValue = nil
                                }))
                                //                            .id(aisle == itemAisle ? vm.selectedItemViewID : nil)
                            }
                        }
                    
                }
                .ssRoundedRectangle(color: .gray, width: 1, cornerRadius: 8)
//                .onAppear {
//                    scrollproxy.scrollTo(vm.selectedItemViewID, anchor: .bottom)
//                }
            }
        }
    }
}

struct PurchasableItemAisleView_Previews: PreviewProvider {
    static var previews: some View {
        PurchasableItemAisleView(aisles: ["aisle one","aisle two"], itemAisle: .constant("aisle two"), focusedTextField: FocusState<TextFieldFocus?>().projectedValue)
    }
}
