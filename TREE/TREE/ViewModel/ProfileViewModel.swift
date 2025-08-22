//
//  ProfileViewModel.swift
//  TREE
//
//  Created by Jaewon Oh on 7/17/25.
//

import Foundation
import Combine
import Firebase
import _PhotosUI_SwiftUI
import SwiftUICore

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var currentUser: Users?
    @Published var treeFeed = [any Tree]()
    private var cancellable = Set<AnyCancellable>()
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { try await loadImage() } }  // without didset, we need to manually call loadimage in UI .onChange
    }
    @Published var profileImage: Image?
    @Published var state = ""
    @Published var city = ""
    @Published var newState = ""
    @Published var newCity = ""
    @Published var errorMessage = ""
    @Published var showAlert = false
    
    let service = ProfileService()
    
    init() {
        setupScribers()
        observeTreeFeed()
        service.observeTreeFeed()
    }
    
    
    func updateLocation() async throws {
        do {
            try await UserService.shared.updateLocation(state: newState, city: newCity)
            currentUser?.state = newState
            currentUser?.city = newCity
            state = newState
            city = newCity
            ViewModelManager.shared.locationDidChange(state: newState, city: newCity)
            newState = ""
            newCity = ""
        } catch {
            newState = ""
            newCity = ""
            errorMessage = UserService.shared.errorMessage
            showAlert = true
            throw error
        }
    }
    
    private func setupScribers() {
        UserService.shared.$currentUser
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.currentUser = user
                self?.state = user?.state ?? "state"
                self?.city = user?.city ?? "city"
                if user != nil {
                    self?.service.observeTreeFeed()
                }
            }
            .store(in: &cancellable)
        }
    
    func observeTreeFeed() {
        service.$treeFeedChanges
            .receive(on: DispatchQueue.main)
            .sink { [weak self] changes in
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
            
        }.store(in: &cancellable)
    }

    private func handleAddedStore(_ change: DocumentChange) {
        let data = change.document.data()
        
        guard !treeFeed.contains(where: { $0.id == data["id"] as! String }) else { return }
        
        if data["shared"] != nil {
            guard let sublet = try? change.document.data(as: Sublets.self) else { return }
            treeFeed.append(sublet)
            print("added sublet to treefeed")
        } else {
            guard let store = try? change.document.data(as: Stores.self) else { return }
            treeFeed.append(store)
            print("added store to treefeed")
        }
    }

    private func handleModifiedStore(_ change: DocumentChange) {
        let data = change.document.data()
        if data["shared"] != nil {
            guard let sublet = try? change.document.data(as: Sublets.self) else { return }
            if let index = treeFeed.firstIndex(where: { $0.id == sublet.id }) {
                treeFeed[index] = sublet
            }
        } else {
            guard let store = try? change.document.data(as: Stores.self) else { return }
            if let index = treeFeed.firstIndex(where: { $0.id == store.id }) {
                treeFeed[index] = store
            }
        }
    }

    private func handleRemovedStore(_ change: DocumentChange) {
        let data = change.document.data()
        if data["shared"] != nil {
            guard let sublet = try? change.document.data(as: Sublets.self) else { return }
            treeFeed.removeAll { $0.id == sublet.id }
        } else {
            guard let store = try? change.document.data(as: Stores.self) else { return }
            treeFeed.removeAll { $0.id == store.id }
        }
    }
        
    
    func deleteTreeFeed(_ feed: any Tree) async {
        do {
            guard let index = treeFeed.firstIndex(where: { $0.id == feed.id }) else { return }
            treeFeed.remove(at: index)
            try await UserService.shared.deleteFeed(treeFeed: feed)
        } catch {
            print("DEBUG: Failed to delete message \(error.localizedDescription)")
        }
    }
    
    func sort() {
        treeFeed.sort { $0.timeStamp.dateValue() > $1.timeStamp.dateValue() }
    }
    
    func loadImage() async throws {
        guard let item = selectedItem else { return }
        guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: imageData) else { return }
        self.profileImage = Image(uiImage: uiImage)
        
        guard let imageUrl = try await ImageUploader().uploadImage(uiImage) else { return }
        try await UserService.shared.updateUserProfileImage(imageUrl)
    }
}
 
