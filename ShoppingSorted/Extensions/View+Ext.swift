//
//  View+Ext.swift
//  ShoppingSorted
//
//  Created by Quinn on 28/08/2023.
//

import SwiftUI

struct SSRoundedRectangle: ViewModifier {
    
    let color: Color
    let width: CGFloat
    let cornerRadius: CGFloat
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(color, lineWidth: width)
            }
    }
}


extension View {
    func ssRoundedRectangle(color: Color, width: CGFloat, cornerRadius: CGFloat) -> some View {
        modifier(SSRoundedRectangle(color: color, width: width, cornerRadius: cornerRadius))
    }
}
