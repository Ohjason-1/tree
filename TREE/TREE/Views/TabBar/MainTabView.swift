//
//  MainTabView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/13/25.
//

import SwiftUI

struct MainTabView: View {
    @Binding var selectedTab: Int
    @EnvironmentObject var messageViewModel: MessagesViewModel
    
    var body: some View {
        TabView(selection: $selectedTab) {
            TreeView()
                .tabItem {
                    Label("Tree", systemImage: selectedTab == 0 ? "tree.fill" : "tree")
                        .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                }
                .tag(0)
            
            MessagesView()
                .tabItem {
                    Label("Messages", systemImage: selectedTab == 1 ? "message.fill" : "message")
                        .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                }
                .badge(messageViewModel.badgeCount)
                .tag(1)
            
            PostView(tabIndex: $selectedTab)
                .tabItem {
                    Label("Post", systemImage: selectedTab == 2 ? "plus.square.fill" : "plus.square")
                        .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                }
                .tag(2)
                .toolbar(.hidden, for: .tabBar)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: selectedTab == 3 ? "person.fill" : "person")
                        .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                }
                .tag(3)
        }
        .tint(Color("AccentColor").gradient)
    }
    
}

#Preview {
    MainTabView(selectedTab: .constant(0))
}
