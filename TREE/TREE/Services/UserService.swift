//
//  UserService.swift
//  TREE
//
//  Created by Jaewon Oh on 7/17/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseMessaging
import FirebaseStorage

class UserService {
    
    @Published var currentUser: Users?
    
    static let shared = UserService()
    @Published var errorMessage = ""
    
    
    
    // MARK: - Fetch
    @MainActor
    func fetchCurrentUser() async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            self.currentUser = nil
            ViewModelManager.shared.userSession = nil
            return
        }
        do {
            let snap = try await FirestoreConstants.UserCollection.document(uid).getDocument()
            guard snap.exists else {
                self.currentUser = nil
                ViewModelManager.shared.userSession = nil
                print("DEBUG: No Firestore user doc for uid \(uid)")
                return
            }
            let user = try snap.data(as: Users.self)
            self.currentUser = user
        } catch {
            // Any decoding / fetch error -> treat as no user
            self.currentUser = nil
            ViewModelManager.shared.userSession = nil
            errorMessage = "Failed to fetch current user."
            throw error
        }
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
    
    // MARK: - Update
    func updateUserProfileImage(_ imageUrl: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        try await FirestoreConstants.UserCollection.document(uid).updateData([
            "userImageUrl": imageUrl
        ])
        
        currentUser?.userImageUrl = imageUrl
    }
    
    func updateFCMToken() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            let token = try await Messaging.messaging().token()
            try await FirestoreConstants.UserCollection.document(uid).setData(["fcmToken": FieldValue.arrayUnion([token])], merge: true)

            // Update local user object if it exists
            if currentUser != nil {
                if currentUser?.fcmToken == nil {
                    currentUser?.fcmToken = [token]
                } else if !(currentUser?.fcmToken.contains(token) ?? false) {
                    currentUser?.fcmToken.append(token)
                }
            }
            
        } catch {
            errorMessage = "Failed to update FCM token"
            throw error
        }
    }
    
    func updateLocation(state: String, city: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            try await FirestoreConstants.UserCollection.document(uid).setData(["state": state, "city": city])

        } catch {
            errorMessage = "Failed to update state and city"
            throw error
        }
    }
    
    // MARK: - Delete
    func deleteFeed(treeFeed: any Tree) async throws {
        let storage = Storage.storage()
        let collection = treeFeed is Sublets ?
            FirestoreConstants.SubletsCollection :
            FirestoreConstants.StoresCollection
        
        try await collection
            .document(treeFeed.state)
            .collection(treeFeed.city)
            .document(treeFeed.id)
            .delete()
        
        for imageUrl in treeFeed.imageURLs {
            let imageRef = storage.reference(forURL: imageUrl)
            try await imageRef.delete()
        }
    }
    
    
    func deleteUser(user: Users, viewModel: ProfileViewModel) async throws {
        let messagesViewModel = await ViewModelManager.shared.messagesViewModel
        let storage = Storage.storage()
        
        // user collection
        try await FirestoreConstants
            .UserCollection
            .document(user.id)
            .delete()
        
        // tree posts
        for tree in await viewModel.treeFeed {
            try await deleteFeed(treeFeed: tree)
        }
        
        for message in await messagesViewModel.recentMessages {
            // user from chatpartner's recent message
            try await FirestoreConstants
                .MessagesCollection
                .document(message.chatPartnerId)
                .collection("recent-messages")
                .document(user.id)
                .delete()
            
            // chat contents from chatpartner to me
            let collectionRef = FirestoreConstants
                .MessagesCollection
                .document(message.chatPartnerId)
                .collection(user.id)
            
            let snapshot = try await collectionRef.getDocuments()
            
            for document in snapshot.documents {
                try await document.reference.delete()
            }
        }
        
        // my recent messages
        let userRecentMessagesRef = FirestoreConstants
                .MessagesCollection
                .document(user.id)
                .collection("recent-messages")
            
        let userRecentSnapshot = try await userRecentMessagesRef.getDocuments()
        for document in userRecentSnapshot.documents {
            try await document.reference.delete()
        }
        
        // // chat contents from me to chatpartner
        try await FirestoreConstants
            .MessagesCollection
            .document(user.id)
            .delete()
        if let profileImageUrl = user.userImageUrl {
            let profileRef = storage.reference(forURL: profileImageUrl)
            try await profileRef.delete()
        }
        try await Auth.auth().currentUser?.delete()
    }
}
