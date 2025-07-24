//
//  UserService.swift
//  TREE
//
//  Created by Jaewon Oh on 7/17/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class UserService {
    
    @Published var currentUser: Users?
    
    static let shared = UserService()
    
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userData = try await FirestoreConstants.UserCollection.document(uid).getDocument()
        let user = try userData.data(as: Users.self) //decode
        self.currentUser = user
    }
    
    static func fetchAllUsers() async throws -> [Users] {
        let rawData = try await FirestoreConstants.UserCollection.getDocuments()
        return rawData.documents.compactMap({ try? $0.data(as: Users.self)})
    }
    
    static func fetchUser(withUid uid: String, completion: @escaping(Users) -> Void) {
        FirestoreConstants.UserCollection.document(uid).getDocument { snapshot, error in
            guard let user = try? snapshot?.data(as: Users.self) else { return }
            completion(user)
        }
    }
    
    func updateUserProfileImage(_ imageUrl: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        try await FirestoreConstants.UserCollection.document(uid).updateData([
            "userImageUrl": imageUrl
        ])
        
        currentUser?.userImageUrl = imageUrl
    }
}
