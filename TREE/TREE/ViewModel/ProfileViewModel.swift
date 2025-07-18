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

class ProfileViewModel: ObservableObject {
    @Published var currentUser: Users?
    
    private var cancellable = Set<AnyCancellable>()
    
    init() {
        setupScribers()
    }
    
    private func setupScribers() {
        UserService.shared.$currentUser.sink { [weak self] user in
            self?.currentUser = user
        }.store(in:&cancellable)
    }
}
 
// MARK:  - profile image viewmodel
class ProfileImageViewModel: ObservableObject {
    @Published var selectedItem: PhotosPickerItem? {
        didSet { Task { try await loadImage() } }  // without didset, we need to manually call loadimage in UI .onChange
    }
    
    @Published var profileImage: Image?
    
    func loadImage() async throws {
        guard let item = selectedItem else { return }
        guard let imageData = try await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: imageData) else { return }
        self.profileImage = Image(uiImage: uiImage)
    }
}
