//
//  RegistrationViewModel.swift
//  TREE
//
//  Created by Jaewon Oh on 7/17/25.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var userName = ""
    @Published var phoneNumber = ""
    @Published var state = ""
    @Published var city = ""
    @Published var errorMessage = ""
    
    func createUser() async throws {
        do {
            try await AuthService.shared.createUser(withEmail: email, password: password, userName: userName, phoneNumber: phoneNumber, state: state, city: city)
        } catch {
            errorMessage = AuthService.shared.errorMessage
            throw error
        }
    }
    
    
}
