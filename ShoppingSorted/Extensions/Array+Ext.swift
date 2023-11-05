//
//  Array+Ext.swift
//  ShoppingSorted
//
//  Created by Quinn on 28/09/2023.
//

import Foundation

extension Array {
    mutating func move(at index: Index, to newIndex: Index) {
        insert(remove(at: index), at: newIndex)
    }
}
