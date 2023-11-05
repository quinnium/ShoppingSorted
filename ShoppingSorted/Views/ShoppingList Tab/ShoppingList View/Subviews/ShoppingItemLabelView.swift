//
//  ShoppingItemLabelView.swift
//  ShoppingSorted
//
//  Created by Quinn on 06/10/2023.
//

import SwiftUI

struct ShoppingItemLabelView: View {
    
    let name: String
    let quantity: Double
    let unit: String
    
    var body: some View {
        HStack(spacing: 5) {
            HStack {
                Text(name)
                    .lineLimit(2)
                    .minimumScaleFactor(0.6)
                    .frame(alignment: .leading)
                Spacer()
                Text(String(format: "%g", quantity))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .frame(alignment: .trailing)
            }
            Text(unit)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .foregroundStyle(Color(uiColor: .systemGray))
                .frame(width: 55, alignment: .leading)
        }
        .foregroundStyle(Color(uiColor: .label))
    }
}

#Preview {
    return ZStack {
        Rectangle()
            .opacity(0.1)
        ShoppingItemLabelView(name: "This is a very very long ingedient and has lots of words", quantity: 1000.2, unit: "tbspp")
    }
    .frame(width: 300)
}
