//
//  ProfileService.swift
//  TREE
//
//  Created by Jaewon Oh on 8/21/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class ProfileService {
    @Published var treeFeedChanges = [DocumentChange]()
    @Published var errorMessages = ""
    
    // MARK: - Treefeed fetch
    func observeTreeFeed() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let query = FirestoreConstants
            .UserCollection
            .document(uid)
            .collection("treeFeed")
            .order(by: "timeStamp", descending: true)
        
        query.addSnapshotListener { snapshot, error in
            guard let changes = snapshot?.documentChanges else { return }
            self.treeFeedChanges = changes
        }
    }
}
