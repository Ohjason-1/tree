//
//  StoresViewModel.swift
//  TREE
//
//  Created by Jaewon Oh on 7/29/25.
//

import Foundation
import _PhotosUI_SwiftUI
import SwiftUICore
import FirebaseAuth
import FirebaseFirestore
import Combine

@MainActor
class StoresViewModel: ObservableObject {
    @Published var stores = [Stores]()
    @Published var zipcode: String = ""
    @Published var address: String = ""
    @Published var city: String = ""
    @Published var state: String = ""
    @Published var price: Int = 0
    @Published var productName: String = "Microwave"
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var images = [UIImage]()
    @Published var errorMessage = ""
    @Published var showingAlert = false
    private var cancellables = Set<AnyCancellable>()
    
    private let profile: ProfileViewModel
    
    let service = StoresService()
    
    
    init(profile: ProfileViewModel) {
        self.profile = profile
        setupStores()
        observeLocationChanges()
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
    
    
    func uploadStore() async throws {
        do {
            guard let imageURLs = try await ImageUploader().uploadPostImage(images, false) else { return }
            try await service.createSubletsPost(zipcode: zipcode, imageURLs: imageURLs, address: address, city: city, state: state, price: price, productName: productName, title: title, description: description)
            selectedImage.removeAll()
        } catch {
            await MainActor.run {
                errorMessage = service.errorMessage
                showingAlert = true
            }
            throw error
        }
    }
    
    func refreshForNewLocation(state: String, city: String) {
        stores.removeAll()
        service.observeStores(state: state, city: city)
    }
    
    private func observeLocationChanges() {
        profile.$city
            .sink { [weak self] city in
                guard let self = self else { return }
                let state = self.profile.state
                guard !state.isEmpty && !city.isEmpty else { return }
                
                self.service.observeStores(state: state, city: city)
            }
            .store(in: &cancellables)
    }
    
    //MARK: - setting up store feeds
    private func setupStores() {
        service.$storeChanges.sink { [weak self] changes in
            guard let self else { return }
            
            for change in changes {
                switch change.type {
                case .added:
                    self.handleAddedStore(change)
                case .modified:
                    self.handleModifiedStore(change)
                case .removed:
                    self.handleRemovedStore(change)
                }
            }
            
        }.store(in: &cancellables)
    }

    private func handleAddedStore(_ change: DocumentChange) {
        guard let store = try? change.document.data(as: Stores.self) else { return }
        
        // Check if already exists to avoid duplicates
        guard !stores.contains(where: { $0.id == store.id }) else { return }
        
        stores.append(store)
        stores.sort { $0.timeStamp.dateValue() > $1.timeStamp.dateValue() }
        
        UserService.fetchUser(withUid: store.ownerUid) { [weak self] user in
            guard let self else { return }
            if let index = self.stores.firstIndex(where: { $0.id == store.id }) {
                self.stores[index].user = user
            }
        }
    }

    private func handleModifiedStore(_ change: DocumentChange) {
        guard let modifiedStore = try? change.document.data(as: Stores.self) else { return }

        if let index = stores.firstIndex(where: { $0.id == modifiedStore.id }) {
            stores[index] = modifiedStore
        }
    }

    private func handleRemovedStore(_ change: DocumentChange) {
        guard let removedSublet = try? change.document.data(as: Stores.self) else { return }
        
        stores.removeAll { $0.id == removedSublet.id }
        // Remove from profile as well
    }
    
}
