//
//  TreeViewModel.swift
//  TREE
//
//  Created by Jaewon Oh on 7/14/25.
//

import Foundation

class TreeViewModel: ObservableObject {
    @Published var sublets: [Sublets] = []
    @Published var stores: [Stores] = []
    @Published var selectedType: TreeType = .sublets
    
    enum TreeType {
        case sublets, stores
    }
    
    private let service: TreeService
    
    init(service: TreeService) {
        self.service = service
        
    }
    
    @MainActor
    func fetchData() async {
        do {
            self.stores = try await service.fetchStores()
        } catch {
            print("DEBUG: Failed to fetch tree data with error: \(error.localizedDescription)")
        }
    }
}


