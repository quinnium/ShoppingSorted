//
//  PurchasableItem+QuantityView.swift
//  ShoppingSorted
//
//  Created by Quinn on 02/09/2023.
//

import SwiftUI

struct PurchasableItemQuantityView: View {
    
    @Binding var itemQuantity: Double
    var focusedTextField: FocusState<PurchasableItemView.TextFieldFocus?>.Binding

    private let quantityFormatter: NumberFormatter = {
        let formatter           = NumberFormatter()
        formatter.locale        = Locale.current
        formatter.numberStyle   = .decimal
        formatter.zeroSymbol    = ""
        return formatter
    }()
    
    var body: some View {
        HStack {
            TextField("Quantity", value: $itemQuantity, formatter: quantityFormatter)
                .frame(width: 100, height: 40)
                .keyboardType(.decimalPad)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .focused(focusedTextField, equals: .quantity)
                .ssRoundedRectangle(color: .gray, width: 1, cornerRadius: 8)
        }
    }
}

struct PurchasableItemQuantityView_Previews: PreviewProvider {
    static var previews: some View {
        PurchasableItemQuantityView(itemQuantity: .constant(20.5), focusedTextField: FocusState<PurchasableItemView.TextFieldFocus?>().projectedValue)
    }
}
