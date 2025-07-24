//
//  Constants.swift
//  TREE
//
//  Created by Jaewon Oh on 7/18/25.
//

import Foundation
import Firebase


struct FirestoreConstants {
    
    static let UserCollection = Firestore.firestore().collection("users")
    static let MessagesCollection = Firestore.firestore().collection("messages")
    static let SubletsCollection = Firestore.firestore().collection("sublets")
    
}
