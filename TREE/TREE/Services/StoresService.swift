//
//  StoresService.swift
//  TREE
//
//  Created by Jaewon Oh on 7/29/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class StoresService {
    @Published var storeChanges = [DocumentChange]()
    
    func observeStores() {
        let query = FirestoreConstants
            .StoresCollection
            .order(by: "timeStamp", descending: true)
        
        query.addSnapshotListener { snapshot, error in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            self.storeChanges = changes
        }
    }
    
    func createSubletsPost(zipcode: String, imageURLs: [String], address: String, city: String, state: String, price: Int, productName: String, title: String, description: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        let ref = FirestoreConstants.StoresCollection.document()
        let id = ref.documentID
        let store = Stores(id: id, ownerUid: currentUid, zipcode: zipcode, imageURLs: imageURLs, address: address, city: city, state: state, price: price, productName: productName, title: title, description: description, timeStamp: Timestamp())
        
        guard let encodedSublet = try? Firestore.Encoder().encode(store) else { return }
        
        try await ref.setData(encodedSublet)
    }
}
