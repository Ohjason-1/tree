//
//  LoginViewModel.swift
//  TREE
//
//  Created by Jaewon Oh on 7/17/25.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    @Published var showingAlert = false
    
    
    func login() async throws {
        do {
            try await AuthService.shared.login(withEmail: email, password: password)
        } catch {
            await MainActor.run {
                errorMessage = AuthService.shared.errorMessage
                showingAlert = true
            }
            throw error
        }
    }
    
    
}
