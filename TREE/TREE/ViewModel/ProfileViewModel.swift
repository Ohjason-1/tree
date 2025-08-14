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
    
    
    init() {
        setupScribers()
    }
    
    @MainActor
    private func setupScribers() {
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in:&cancellable)
    }
    
    func addUserPost(_ post: any Tree) {
        print("2")
        treeFeed.append(post)
        sort()
        print("treefeed: \(treeFeed)")
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
 
