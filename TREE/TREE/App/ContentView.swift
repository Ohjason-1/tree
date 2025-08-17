//
//  ContentView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/13/25.
//

import SwiftUI
import UserNotifications

struct ContentView: View {
    @State private var showingLogo = true
    @ObservedObject var viewModelManager = ViewModelManager.shared
    @State private var selectedChatUser: Users?
    @State private var shouldNavigateToChat = false
    @State private var selectedTab = 0
    
    // hard coded to show logo screen >,<
    var body: some View {
        Group {
            if showingLogo {
                LogoScreen()
            } else if shouldNavigateToChat, let user = selectedChatUser {
                ChatView(user: user, shouldNavigateToChat: $shouldNavigateToChat)
            } else if viewModelManager.userSession != nil {
                MainTabView(selectedTab: $selectedTab)
                    .environmentObject(viewModelManager.profileViewModel)
                    .environmentObject(viewModelManager.subletsViewModel)
                    .environmentObject(viewModelManager.storesViewModel)
                    .environmentObject(viewModelManager.messagesViewModel)
            } else {
                LoginView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    showingLogo = false
                }
            }
            
            NotificationCenter.default.addObserver(
                forName: .openChatFromNotification,
                object: nil,
                queue: .main
            ) { notification in
                handleNotificationNavigation(notification)
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self, name: .openChatFromNotification, object: nil)
        }
    }
    private func handleNotificationNavigation(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let senderId = userInfo["senderId"] as? String else { return }
            // fetch user object
        UserService.fetchUser(withUid: senderId) { user in
            selectedChatUser = user
        }
        shouldNavigateToChat = true
        selectedTab = 1
        }
}

#Preview {
    ContentView()
}
