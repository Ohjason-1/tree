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
    
    func createUser() async throws {
        try await AuthService.shared.createUser(withEmail: email, password: password, userName: userName, phoneNumber: phoneNumber)
    }
}
