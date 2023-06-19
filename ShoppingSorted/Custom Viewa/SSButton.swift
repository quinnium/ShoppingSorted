//
//  ssButton.swift
//  ShoppingSorted
//
//  Created by Quinn on 27/03/2023.
//

import SwiftUI

struct SSButton: View {

    let title: String
    let isEnabled: Bool
    let color: Color
    let width: CGFloat
    let height: CGFloat
    let bordered: Bool
    
    init(title: String, isEnabled: Bool, color: Color, bordered: Bool = false, width: CGFloat, height: CGFloat) {
        self.title = title
        self.isEnabled = isEnabled
        self.color = color
        self.width = width
        self.height = height
        self.bordered = bordered
    }
    var body: some View {
        Text(title)
            .font(.system(size: 20, weight: .medium))
            .frame(width: width ,height: height)
            .padding(10)
            .background(isEnabled ? (bordered ? .clear : color) : (bordered ? .clear : .gray))
            .foregroundColor(bordered ? color : .white)
            .cornerRadius(10)
            .ssRoundedRectangle(color: bordered ? color : .clear, width: 2, cornerRadius: 10)
    }
}


struct ssButton_Previews: PreviewProvider {
    static var previews: some View {
        SSButton(title: "Test", isEnabled: true, color: .green, width: 100, height: 30)
    }
}
