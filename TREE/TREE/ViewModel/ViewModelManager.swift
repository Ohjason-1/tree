//
//  ViewModelManager.swift
//  TREE
//
//  Created by Jaewon Oh on 8/13/25.
//

import Foundation

@MainActor
class ViewModelManager: ObservableObject {
    @Published var profileViewModel = ProfileViewModel()
    @Published var subletsViewModel = SubletsViewModel()
    @Published var storesViewModel = StoresViewModel()
    @Published var messagesViewModel = MessagesViewModel()
    
    static let shared = ViewModelManager()
    
    func resetAllViewModels() {
        profileViewModel = ProfileViewModel()
        subletsViewModel = SubletsViewModel()
        storesViewModel = StoresViewModel()
        messagesViewModel = MessagesViewModel()
    }
}
