//
//  MainTabView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/13/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @EnvironmentObject var messageViewModel: MessagesViewModel
    var body: some View {
        TabView(selection: $selectedTab) {
            TreeView()
                .tabItem {
                    Label("Tree", systemImage: selectedTab == 0 ? "tree.fill" : "tree")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                }
                .onAppear { selectedTab = 0 }
                .tag(0)
            
            MessagesView()
                .tabItem {
                    Label("Messages", systemImage: selectedTab == 1 ? "message.fill" : "message")
                        .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                }
                .badge(messageViewModel.badgeCount)
                .onAppear { selectedTab = 1 }
                .tag(1)
            
            PostView(tabIndex: $selectedTab)
                .tabItem {
                    Label("Post", systemImage: selectedTab == 2 ? "plus.square.fill" : "plus.square")
                        .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                }
                .onAppear { selectedTab = 2 }
                .tag(2)
                .toolbar(.hidden, for: .tabBar)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: selectedTab == 3 ? "person.fill" : "person")
                        .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                }
                .onAppear { selectedTab = 3 }
                .tag(3)
        }
        .tint(Color("AccentColor"))
    }
    
}

#Preview {
    MainTabView()
}
