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
    
    // hard coded to show logo screen >,<
    var body: some View {
        Group {
            if showingLogo {
                LogoScreen()
            } else if viewModelManager.userSession != nil {
                MainTabView()
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
        }
    }
}

#Preview {
    ContentView()
}
