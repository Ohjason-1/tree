//
//  MessageService.swift
//  TREE
//
//  Created by Jaewon Oh on 7/18/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class MessagesService {
    @Published var documentChanges = [DocumentChange]()
    
    
    func observeRecentMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let query = FirestoreConstants
            .MessagesCollection
            .document(uid)
            .collection("recent-messages")
            .order(by: "timeStamp", descending: false)
        
        query.addSnapshotListener { snapshot, error in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added || $0.type == .modified }) else { return }
            self.documentChanges = changes
        }
    }
    
    func deleteConversation(recentMessage: Messages) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let chatPartner = recentMessage.user else { return }
        
        let snapshot = try await FirestoreConstants
            .MessagesCollection
            .document(uid)
            .collection(chatPartner.id)
            .getDocuments()
        
        for doc in snapshot.documents {
            try await FirestoreConstants
                .MessagesCollection
                .document(uid)
                .collection(chatPartner.id)
                .document(doc.documentID)
                .delete()
        }
        
        try await FirestoreConstants
            .MessagesCollection
            .document(uid)
            .collection("recent-messages")
            .document(recentMessage.id)
            .delete()
    }
}
