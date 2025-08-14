//
//  ContentViewModel.swift
//  TREE
//
//  Created by Jaewon Oh on 7/17/25.
//

import FirebaseAuth
import Combine
import UserNotifications

class ContentViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    
    private var cancellable = Set<AnyCancellable>()
    private var currentUserId: String?
    
    init() {
        setupSubscribers()
    }
    
    //@MainActor
    private func setupSubscribers() {
        AuthService.shared.$userSession.receive(on: DispatchQueue.main).sink { [weak self] userSessionFromAuthService in
            self?.userSession = userSessionFromAuthService
        }.store(in: &cancellable)
    }
}
