//
//  StringProtocol+Ext.swift
//  ShoppingSorted
//
//  Created by Quinn on 16/10/2023.
//

import Foundation

extension StringProtocol {
    var firstUppercased: String { return prefix(1).uppercased() + dropFirst() }
}
