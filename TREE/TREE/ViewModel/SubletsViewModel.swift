//
//  SubletsViewModel.swift
//  TREE
//
//  Created by Jaewon Oh on 7/18/25.
//

import Foundation
import _PhotosUI_SwiftUI
import SwiftUICore
import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
class SubletsViewModel: ObservableObject {
    @Published var sublets = [Sublets]()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var numberOfBedrooms = "0"
    @Published var numberOfBathrooms = "0"
    @Published var zipcode: String = ""
    @Published var address: String = ""
    @Published var city: String = ""
    @Published var state: String = ""
    @Published var shared: Bool = false
    @Published var leaseStartDate: Date = Date()
    @Published var leaseEndDate: Date = Date()
    @Published var rentFee: Int = 0
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var images = [UIImage]()
    
    let service = SubletsService()
    
    init() {
          setupSublets()
          service.observeSublets()
      }
    
    @Published var selectedImage: [PhotosPickerItem] = [] {
        didSet {Task { await loadImage(fromItems: selectedImage) }  }
    }
    
    func loadImage(fromItems items: [PhotosPickerItem]) async {
        images.removeAll()
        for item in items {
            guard let data = try? await item.loadTransferable(type: Data.self) else { return }
            guard let uiImage = UIImage(data: data) else { return }
            images.append(uiImage)
        }
    }
    
    func uploadSublet() async throws {
        guard let imageURLs = try await ImageUploader().uploadPostImage(images, true) else { return }
        try await service.createSubletsPost(numberOfBedrooms: numberOfBedrooms, numberOfBathrooms: numberOfBathrooms, zipcode: zipcode, imageURLs: imageURLs, address: address, city: city, state: state, shared: shared, leaseStartDate: leaseStartDate, leaseEndDate: leaseEndDate, rentFee: rentFee, title: title, description: description)
    }
    
    private func setupSublets() {
        service.$subletChanges.sink { [weak self] changes in
            guard let self else { return }
            
            // Clear existing data when new changes arrive
            self.sublets.removeAll()
            
            let subletData = changes.compactMap({ try? $0.document.data(as: Sublets.self )})
            
            // Sort by timestamp to ensure consistent order
            let sortedSublets = subletData.sorted { $0.timeStamp.dateValue() > $1.timeStamp.dateValue() }
            
            for sublet in sortedSublets {
                self.sublets.append(sublet)
                UserService.fetchUser(withUid: sublet.ownerUid) { [weak self] user in
                    guard let self else { return }
                    if let index = self.sublets.firstIndex(where: { $0.id == sublet.id }) {
                        self.sublets[index].user = user
                    }
                }
            }
            
        }.store(in: &cancellables)
    }
}
