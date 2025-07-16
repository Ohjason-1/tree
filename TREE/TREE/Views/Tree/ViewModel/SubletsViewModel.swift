//
//  SubletsViewModel.swift
//  TREE
//
//  Created by Jaewon Oh on 7/14/25.
//

import Foundation


class SubletsViewModel: ObservableObject {
    @Published var sublets = [Sublets]()
    private let service: SubletsService
    
    init(service: SubletsService) {
        self.service = service
        
        Task { await fetchListings() }
    }
    
    @MainActor
    func fetchListings() async {
        do {
            self.sublets = try await service.fetchListings()
        } catch {
            print("DEBUG: Failed to fetch subet listings with error: \(error.localizedDescription)")
        }
    }
}
