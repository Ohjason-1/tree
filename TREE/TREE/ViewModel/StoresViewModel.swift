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
    private var cancellables = Set<AnyCancellable>()
    
    @Published var zipcode: String = ""
    @Published var address: String = ""
    @Published var city: String = ""
    @Published var state: String = ""
    @Published var price: Int = 0
    @Published var productName: String = "Microwave"
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var images = [UIImage]()
    
    let service = StoresService()
    
    init() {
        setupStores()
        service.observeStores()
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
        guard let imageURLs = try await ImageUploader().uploadPostImage(images, false) else { return }
        try await service.createSubletsPost(zipcode: zipcode, imageURLs: imageURLs, address: address, city: city, state: state, price: price, productName: productName, title: title, description: description)
    }
    
    private func setupStores() {
        service.$storeChanges.sink { [weak self] changes in
            guard let self else { return }
            var storeData = changes.compactMap({ try? $0.document.data(as: Stores.self )})
            for i in 0..<storeData.count {
                let store = storeData[i]
                UserService.fetchUser(withUid: store.ownerUid) { user in
                    storeData[i].user = user
                    self.stores.insert(storeData[i], at: 0)
                }
            }
            
        }.store(in: &cancellables)
    }
    
}
