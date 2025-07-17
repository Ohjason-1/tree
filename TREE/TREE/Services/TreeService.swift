//
//  TreeService.swift
//  TREE
//
//  Created by Jaewon Oh on 7/14/25.
//

import Foundation


class TreeService {
    func fetchSublets() async throws -> [Sublets] {
        return DeveloperPreview.shared.sublets
    }
    
    func fetchStores() async throws -> [Stores] {
        return DeveloperPreview.shared.stores
    }
}
