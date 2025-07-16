//
//  Users.swift
//  TREE
//
//  Created by Jaewon Oh on 7/15/25.
//

import Foundation

struct Users: Identifiable, Codable, Hashable {
    let id: String
    let email: String
    let userName: String
    let phoneNumber: Int
}
