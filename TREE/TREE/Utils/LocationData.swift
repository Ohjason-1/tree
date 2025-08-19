//
//  LocationData.swift
//  TREE
//
//  Created by Jaewon Oh on 8/18/25.
//

import Foundation

struct LocationData {
    static var statesCities: [String: [String]] = [
        "California": ["San Francisco", "Los Angeles", "San Diego", "Oakland", "Berkeley", "Palo Alto"],
        "New York": ["New York City", "Albany", "Buffalo", "Rochester", "Syracuse"],
        "Texas": ["Austin", "Houston", "Dallas", "San Antonio", "Fort Worth"],
        "Massachusetts": ["Boston", "Cambridge", "Worcester", "Springfield"],
        "Washington": ["Seattle", "Spokane", "Tacoma", "Vancouver"],
        // Add more states as needed
    ]
    
    static var allStates: [String] {
        return Array(statesCities.keys).sorted()
    }
    
    static func cities(for state: String) -> [String] {
        return statesCities[state]?.sorted() ?? []
    }
}
