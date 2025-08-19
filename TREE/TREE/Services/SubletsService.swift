//
//  SubletsService.swift
//  TREE
//
//  Created by Jaewon Oh on 7/14/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class SubletsService {
    // MARK: - Sublet service
    @Published var subletChanges = [DocumentChange]()
    @Published var errorMessage = ""
    
    @MainActor func observeSublets() {
        let query = FirestoreConstants
            .SubletsCollection
            .document(ViewModelManager.shared.state)
            .collection(ViewModelManager.shared.city)
            .order(by: "timeStamp", descending: true)
        
        query.addSnapshotListener { snapshot, error in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            self.subletChanges = changes
        }
    }
    
    func createSubletsPost(numberOfBedrooms: String, numberOfBathrooms: String, zipcode: String, imageURLs: [String], address: String, city: String, state: String, shared: Bool, leaseStartDate: Date, leaseEndDate: Date, rentFee: Int, title: String, description: String) async throws {
        do {
            guard let currentUid = Auth.auth().currentUser?.uid else { return }
            let ref = FirestoreConstants.SubletsCollection.document(state).collection(city).document()
            let id = ref.documentID
            let sublet = Sublets(id: id, ownerUid: currentUid, numberOfBedrooms: numberOfBedrooms, numberOfBathrooms: numberOfBathrooms, zipcode: zipcode, imageURLs: imageURLs, address: address, city: city, state: state, shared: shared, leaseStartDate: leaseStartDate, leaseEndDate: leaseEndDate, rentFee: rentFee, title: title, description: description, timeStamp: Timestamp())
            
            guard let encodedSublet = try? Firestore.Encoder().encode(sublet) else { return }
            
            try await ref.setData(encodedSublet)
        } catch {
            errorMessage = "Failed to create a sublet post."
            throw error
        }
    }
    
    
    // MARK: - Store service
//    func fetchStores() async throws -> [Stores] {
//        return DeveloperPreview.shared.stores
//    }
    
}
