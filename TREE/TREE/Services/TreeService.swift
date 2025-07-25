//
//  TreeService.swift
//  TREE
//
//  Created by Jaewon Oh on 7/14/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class TreeService {
    // MARK: - Sublet service
    @Published var subletChanges = [DocumentChange]()
    
    func observeSublets() {
        let query = FirestoreConstants
            .SubletsCollection
            .order(by: "timeStamp", descending: true)
        
        query.addSnapshotListener { snapshot, error in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }
            self.subletChanges = changes
        }
    }
    
    func createSubletsPost(numberOfBedrooms: String, numberOfBathrooms: String, zipcode: String, imageURLs: [String], address: String, city: String, state: String, shared: Bool, leaseStartDate: Date, leaseEndDate: Date, rentFee: Int, title: String, description: String) async throws {
        guard let currentUid = Auth.auth().currentUser?.uid else { return }
        guard let user = UserService.shared.currentUser else { return }
        let ref = FirestoreConstants.SubletsCollection.document()
        let id = ref.documentID
        let sublet = Sublets(id: id, ownerUid: currentUid, ownerName: user.userName, ownerImageUrl: user.userImageUrl ?? "", numberOfBedrooms: numberOfBedrooms, numberOfBathrooms: numberOfBathrooms, zipcode: zipcode, imageURLs: imageURLs, address: address, city: city, state: state, shared: shared, leaseStartDate: leaseStartDate, leaseEndDate: leaseEndDate, rentFee: rentFee, title: title, description: description, timeStamp: Timestamp())
        
        guard let encodedSublet = try? Firestore.Encoder().encode(sublet) else { return }
        
        try await ref.setData(encodedSublet)
    }
    
    
    // MARK: - Store service
    func fetchStores() async throws -> [Stores] {
        return DeveloperPreview.shared.stores
    }
    
}
