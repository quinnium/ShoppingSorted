//
//  BadgeNotificationView.swfit.swift
//  ShoppingSorted
//
//  Created by AQ on 03/05/2023.
//

import Foundation
import SwiftUI

struct BadgeNotificationView: View {
    
    @EnvironmentObject var vm: BadgeNotificationViewModel
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Capsule()
                    .foregroundColor(.red)
                Text(vm.text)
                    .foregroundColor(.white)
                    .bold()
            }
            .frame(width: 40, height: 35)
            .offset(x: (geo.size.width / 4) - 20, y: -15) // base offset
            .frame(width: geo.size.width, height: geo.size.height, alignment: .bottomLeading) // To account for geometryReader
            .offset(y: -35 * vm.percentMoveAnimated) // animate offset
            .opacity(1 - vm.percentFadeAnimated)
            .id(vm.badgeViewID)
            
            .onChange(of: vm.badgeViewID) { _ in
                
                withAnimation(.linear(duration: 1)) {
                    vm.percentMoveAnimated = 1
                }
                withAnimation(.linear(duration: 1).delay(1)) {
                    vm.percentFadeAnimated = 1
                }
            }
        }
    }
}



struct BadgeNotificationView_Preview: PreviewProvider {
    static var previews: some View {
        BadgeNotificationView()
            .environmentObject(BadgeNotificationViewModel())
    }
}
