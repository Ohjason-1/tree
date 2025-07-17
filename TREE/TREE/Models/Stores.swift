//
//  Stores.swift
//  TREE
//
//  Created by Jaewon Oh on 7/16/25.
//

import Foundation

// used products and furnitures when moving out
struct Stores: TreePost {
    let id: String
    let productName: String
    let ownerUid: String
    let ownerName: String
    let ownerImageUrl: String
    let latitude: Double
    let longitude: Double
    let zipcode: String
    var imageURLs: [String]
    let address: String
    let city: String
    let state: String
    var price: Int
    let title: String
    let explanation: String
} 