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
        AuthService.shared.$userSession.sink { [weak self] userSessionFromAuthService in
            let newUserId = userSessionFromAuthService?.uid
            let previousUserId = self?.currentUserId
            
            // If user changed (login/logout/switch)
            if previousUserId != newUserId {
                self?.currentUserId = newUserId
                UserInfo.currentUserId = newUserId ?? ""
                
                
                // Clear badge count
                DispatchQueue.main.async {
                    UNUserNotificationCenter.current().setBadgeCount(0) { _ in }
                }
            }
            self?.userSession = userSessionFromAuthService
        }.store(in: &cancellable)
    }
}
