//
//  ContentView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/13/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isLoggedIn = false
    @State private var showingLogo = true
    // hard coded to show logo screen and login screen >,<
    var body: some View {
        if showingLogo {
            LogoScreen()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            showingLogo = false
                        }
                    }
                }
        } else {
            if isLoggedIn {
                MainTabView()
            } else {
                LoginView(isLoggedIn: $isLoggedIn)
            }
        }
    }
}

#Preview {
    ContentView()
}
