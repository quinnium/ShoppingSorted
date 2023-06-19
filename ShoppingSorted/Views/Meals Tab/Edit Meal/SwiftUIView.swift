//
//  SwiftUIView.swift
//  ShoppingSorted
//
//  Created by Quinn on 30/05/2023.
//

import SwiftUI

struct SwiftUIView: View {
    @State var text = ""
    
    var body: some View {
        TextField("Meal Name nsjkxskn xsnx s xks", text: $text, axis: .vertical)
            .font(.largeTitle)
            .border(.blue)
    }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}
