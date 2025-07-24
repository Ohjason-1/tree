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
        TabView(selection: $selectedTab) {
            TreeView()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 0 ? "tree.fill" : "tree")
                            .environment(\.symbolVariants, selectedTab == 0 ? .fill : .none)
                        Text("Tree")
                    }
                }
                .onAppear { selectedTab = 0 }
                .tag(0)
            
            MessagesView()
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 1 ? "message.fill" : "message")
                            .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                        Text("Messages")
                    }
                }
                .onAppear { selectedTab = 1 }
                .tag(1)
            
            SubletPostView(tabIndex: $selectedTab)
                .tabItem {
                    VStack {
                        Image(systemName: selectedTab == 1 ? "plus.square" : "plus.square.fill")
                            .environment(\.symbolVariants, selectedTab == 1 ? .fill : .none)
                        Text("Post")
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
