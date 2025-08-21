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
    @Published var errorMessage = ""
    func observeStores(state: String, city: String) {
        guard !state.isEmpty && !city.isEmpty else { return }
        let query = FirestoreConstants
            .StoresCollection
            .document(state)
            .collection(city)
            .order(by: "timeStamp", descending: true)
        
        query.addSnapshotListener { snapshot, error in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            self.storeChanges = changes
        }
    }
    
//    func replace() {
//        let db = Firestore.firestore()
//
//        let oldCollectionRef = db.collection("stores")
//        let newCollectionRef = db
//            .collection("stores")
//            .document("California")
//            .collection("Berkeley")
//
//        oldCollectionRef.getDocuments { (snapshot, error) in
//            if let error = error {
//                print("Error getting documents: \(error)")
//                return
//            }
//
//            guard let documents = snapshot?.documents else {
//                print("No documents found in 'stores'")
//                return
//            }
//
//            for document in documents {
//                let data = document.data()
//                let docID = document.documentID
//
//                let newDocRef = newCollectionRef.document(docID)
//                newDocRef.setData(data) { error in
//                    if let error = error {
//                        print("Error writing new document \(docID): \(error)")
//                    } else {
//                        // Delete the original document after copying
//                        oldCollectionRef.document(docID).delete { error in
//                            if let error = error {
//                                print("Error deleting old document \(docID): \(error)")
//                            } else {
//                                print("Moved document \(docID) successfully.")
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
    func createSubletsPost(zipcode: String, imageURLs: [String], address: String, city: String, state: String, price: Int, productName: String, title: String, description: String) async throws {
        do {
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            let ref = FirestoreConstants.StoresCollection.document(state).collection(city).document()
            let id = ref.documentID
            let store = Stores(id: id, ownerUid: currentUid, zipcode: zipcode, imageURLs: imageURLs, address: address, city: city, state: state, price: price, productName: productName, title: title, description: description, timeStamp: Timestamp())
            
            guard let encodedSublet = try? Firestore.Encoder().encode(store) else { return }
            
            try await ref.setData(encodedSublet)
        } catch {
            errorMessage = "Failed to create a store post"
            throw error
        }
    }
}
