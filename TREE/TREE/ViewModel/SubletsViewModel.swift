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
    
    private let profile: ProfileViewModel
    
    let service = SubletsService()
    
    init(profile: ProfileViewModel) {
        self.profile = profile
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
            
            for change in changes {
                switch change.type {
                case .added:
                    self.handleAddedSublet(change)
                case .modified:
                    self.handleModifiedSublet(change)
                case .removed:
                    self.handleRemovedSublet(change)
                }
            }
            
        }.store(in: &cancellables)
    }

    private func handleAddedSublet(_ change: DocumentChange) {
        guard let sublet = try? change.document.data(as: Sublets.self) else { return }
        
        // Check if already exists to avoid duplicates
        guard !sublets.contains(where: { $0.id == sublet.id }) else { return }
        
        sublets.append(sublet)
        sublets.sort { $0.timeStamp.dateValue() > $1.timeStamp.dateValue() }
        
        UserService.fetchUser(withUid: sublet.ownerUid) { [weak self] user in
            guard let self else { return }
            if let index = self.sublets.firstIndex(where: { $0.id == sublet.id }) {
                self.sublets[index].user = user
            }
            if user.id == UserInfo.currentUserId {
                profile.addUserPost(sublet)
            }
        }
    }

    private func handleModifiedSublet(_ change: DocumentChange) {
        guard let modifiedSublet = try? change.document.data(as: Sublets.self) else { return }
        
        if let index = sublets.firstIndex(where: { $0.id == modifiedSublet.id }) {
            sublets[index] = modifiedSublet
            // Update in profile as well
        }
    }

    private func handleRemovedSublet(_ change: DocumentChange) {
        guard let removedSublet = try? change.document.data(as: Sublets.self) else { return }
        
        sublets.removeAll { $0.id == removedSublet.id }
        // Remove from profile as well
    }
}
