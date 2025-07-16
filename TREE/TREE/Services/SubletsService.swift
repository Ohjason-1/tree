//
//  SubletsService.swift
//  TREE
//
//  Created by Jaewon Oh on 7/14/25.
//

import Foundation

class SubletsService {
    func fetchListings() async throws -> [Sublets] {
        return DeveloperPreview.shared.sublets
    }
}
