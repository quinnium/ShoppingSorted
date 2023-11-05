//
//  PurchasableItem+NameView.swift
//  ShoppingSorted
//
//  Created by Quinn on 01/09/2023.
//

import SwiftUI

struct PurchasableItemNameView: View {
    @Binding var itemName: String
    var textFieldFocus: FocusState<TextFieldFocus?>.Binding
    
    var body: some View {
        HStack(spacing: 15) {
            TextField("Item name", text: $itemName)
                .font(.system(size: 30, weight: .medium))
                .lineLimit(1)
                .minimumScaleFactor(0.3)
                .padding(.vertical, 5)
                .submitLabel(.next)
                .focused(textFieldFocus, equals: .name)
                .onSubmit { textFieldFocus.wrappedValue = .quantity }
            if textFieldFocus.wrappedValue == .name {
                Button {
                    itemName = ""
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.gray)
                }
                .frame(width: 15, height: 15)
            }
        }
        .padding(.horizontal, 15)
        .ssRoundedRectangle(color: .gray, width: 1, cornerRadius: 8)
    }
}

struct PurchasableItemNameView_Previews: PreviewProvider {
    static var previews: some View {
        PurchasableItemNameView(itemName: .constant("Test"), textFieldFocus: FocusState<TextFieldFocus?>().projectedValue)
    }
}
