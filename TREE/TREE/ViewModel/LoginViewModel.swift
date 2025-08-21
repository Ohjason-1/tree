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
    @Published var isLoading = false
    
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
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func sendPasswordReset() async throws {
        do {
            isLoading = true
            try await AuthService.shared.resetPassword(email: email)
            isLoading = false
        } catch {
            isLoading = false
            errorMessage = "Failed to reset password"
            throw error
        }
    }
}
