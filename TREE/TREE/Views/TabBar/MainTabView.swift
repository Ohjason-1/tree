//
//  MainTabView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/13/25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 0 ? "house.fill" : "house")
                            .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                        Text("Home")
                    }
                }
                .onAppear { selectedTab = 0 }
                .tag(0)
            
            
            TreeView()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 1 ? "tree.fill" : "tree")
                            .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                        Text("Tree")
                    }
                }
                .onAppear { selectedTab = 1 }
                .tag(1)
            
            MessagesView()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 2 ? "message.fill" : "message")
                            .environment(\.symbolVariants, selectedTab == 2 ? .fill : .none)
                        Text("Messages")
                    }
                }
                .onAppear { selectedTab = 2 }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 3 ? "person.fill" : "person")
                            .environment(\.symbolVariants, selectedTab == 3 ? .fill : .none)
                        Text("Profile")
                    }
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
