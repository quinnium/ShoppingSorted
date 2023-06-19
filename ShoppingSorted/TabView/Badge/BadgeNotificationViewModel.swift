//
//  BadgeNotificationViewModel.swift
//  ShoppingSorted
//
//  Created by AQ on 03/05/2023.
//

import SwiftUI

class BadgeNotificationViewModel: ObservableObject {
    
    @Published var text: String             = ""
    @Published var percentMoveAnimated: CGFloat = 1
    @Published var percentFadeAnimated: Double = 1
    @Published var badgeViewID = 1
    
    
    func updateBadge(value: Int) {
        // effectively resets view/animation
        badgeViewID += 1
        percentFadeAnimated = .zero
        percentMoveAnimated = .zero
        
        if value < 100 && value > 0 {
            text = "+\(value.description)"
        } else if value >= 100 {
            text = ">99"
        } else {
            text = ""
        }
    }
}
