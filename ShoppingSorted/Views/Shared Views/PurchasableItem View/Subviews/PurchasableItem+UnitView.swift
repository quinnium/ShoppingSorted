//
//  PurchasableItem+UnitView.swift
//  ShoppingSorted
//
//  Created by Quinn on 02/09/2023.
//

import SwiftUI

struct PurchasableItemUnitView: View {
    let units: [String]
    @Binding var itemUnit: String
    var focusedTextField: FocusState<PurchasableItemView.TextFieldFocus?>.Binding
    
    var body: some View {
        Picker("", selection: $itemUnit) {
            ForEach(units, id: \.self) { unit in
                Text(unit)
            }
        }
        .fixedSize()
        .pickerStyle(.menu)
        .frame(height: 40)
        .ssRoundedRectangle(color: .gray, width: 1, cornerRadius: 8)
        .onTapGesture {
            focusedTextField.wrappedValue = nil
            print("tapped")
        }
    }
}

struct PurchasableItemUnitView_Previews: PreviewProvider {
    static var previews: some View {
        PurchasableItemUnitView(units: ["one", "two"], itemUnit: .constant("one"), focusedTextField: FocusState<PurchasableItemView.TextFieldFocus?>().projectedValue)
    }
}

