//
//  ContentView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/13/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
        @State private var showLoginView = false
        @State private var showLogoScreen = false
        
        var body: some View {
            ZStack {
                MainTabView()
                
                if showLoginView {
                    LoginView()
                }
                
                if showLogoScreen {
                    LogoScreen()
                }
            }
            .onChange(of: scenePhase) { oldPhase, newPhase in
                switch newPhase {
                case .active:
                    showLoginView = true
                    showLogoScreen = false
                case .inactive:
                    showLoginView = false
                    showLogoScreen = false
                case .background:
                    showLoginView = false
                    showLogoScreen = true
                @unknown default:
                    break
                }
            }
        }
    }

#Preview {
    ContentView()
}
