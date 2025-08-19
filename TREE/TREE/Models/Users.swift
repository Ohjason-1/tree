//
//  Users.swift
//  TREE
//
//  Created by Jaewon Oh on 7/15/25.
//

import Foundation
import FirebaseFirestore

struct Users: Identifiable, Codable, Hashable {
    @DocumentID var uid: String?
    let email: String
    var userName: String
    var phoneNumber: String
    var userImageUrl: String? = nil
    var fcmToken: [String] = []
    var state: String
    var city: String
    
    var id: String {
        return uid ?? NSUUID().uuidString
    }
}
