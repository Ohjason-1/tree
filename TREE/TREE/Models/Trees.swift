//
//  Sublets.swift
//  TREE
//
//  Created by Jaewon Oh on 7/14/25.
//

import Foundation


protocol Tree: Identifiable, Codable, Hashable {
    var id: String { get }
    var ownerUid: String { get }
    var ownerName: String { get }
    var ownerImageUrl: String { get }
    var imageURLs: [String] { get }
    var address: String { get }
    var city: String { get }
    var state: String { get }
    var title: String { get }
    var explanation: String { get }
    var latitude: Double { get }
    var longitude: Double { get }
    var zipcode: String { get }
}

struct Sublets: Tree {
    let id: String
    let ownerUid: String
    let ownerName: String
    let ownerImageUrl: String
    let numberOfBedrooms: Int
    let numberOfBathrooms: Int
    let latitude: Double
    let longitude: Double
    let zipcode: String
    let imageURLs: [String]
    let address: String
    let city: String
    let state: String
    let shared: Bool
    let leaseTermMonth: String
    let leaseTermYear: String
    var rentFee: Int
    let title: String
    let explanation: String
}

struct Stores: Tree {
    let id: String
    let productName: String
    let ownerUid: String
    let ownerName: String
    let ownerImageUrl: String
    let latitude: Double
    let longitude: Double
    let zipcode: String
    let imageURLs: [String]
    let address: String
    let city: String
    let state: String
    var price: Int
    let title: String
    let explanation: String
}

