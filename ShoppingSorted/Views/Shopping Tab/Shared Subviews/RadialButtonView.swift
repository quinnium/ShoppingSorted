//
//  RadialButtonView.swift
//  ShoppingSorted
//
//  Created by Quinn on 09/09/2023.
//

import SwiftUI

struct RadialButtonView: View {
    
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(isSelected ? Color.green : Color.gray, lineWidth: 1)
                .foregroundColor(.clear)
                .frame(width: 24)
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.green)
                    .frame(width: 18)
            }
        }
    }
}

struct RadialButtonView_Previews: PreviewProvider {
    static var previews: some View {
        RadialButtonView(isSelected: true)
    }
}
