//
//  SearchResultsItem.swift
//  ShoppingSorted
//
//  Created by Quinn on 16/10/2023.
//

import Foundation

// This object is used within PurchasableItemView as part of the search results.
struct SearchResultItem: Hashable {
    let name: String
    let unit: String
    let aisle: String
}
