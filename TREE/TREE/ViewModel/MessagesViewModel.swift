//
//  MessagesViewModel.swift
//  TREE
//
//  Created by Jaewon Oh on 7/17/25.
//

import Foundation


class MessagesViewModel: ObservableObject {
    @Published var users = [Users]()
    
    init() {
        Task { try await fetchUsers() }
    }
    @MainActor
    func fetchUsers() async throws {
        self.users = try await UserService.fetchAllUsers()
    }
}
