//
//  Sublets.swift
//  TREE
//
//  Created by Jaewon Oh on 7/14/25.
//

import Foundation

struct Sublets: Identifiable, Codable, Hashable {
    let id: String
    let ownerUid: String
    let ownerName: String
    let ownerImageUrl: String
    let numberOfBedrooms: Int
    let numberOfBathrooms: Int
    let latitude: Double
    let longitude: Double
    let zipcode: String
    var imageURLs: [String]
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


