//
//  AuthService.swift
//  TREE
//
//  Created by Jaewon Oh on 7/17/25.
//

import Foundation
import FirebaseAuth
import Firebase
import FirebaseFirestore

class AuthService {
    
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService() // without this, we have multiple of usersession.
    
    // only called when first auth initialization, after killing the app.
    init() {
        self.userSession = Auth.auth().currentUser
        loadCurrentUserData()
    }
    
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            loadCurrentUserData()
        } catch {
            print("DEBUG: failed to sign in user with error \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createUser(withEmail email: String, password: String, userName: String, phoneNumber: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            try await self.uploadUserData(email: email, userName: userName, phoneNumber: phoneNumber, id: result.user.uid)
            loadCurrentUserData()
        } catch {
            print("DEBUG: failed to create user with error \(error.localizedDescription)")
        }
    }
    
    // synchronous function - does not need @mainactor
    func signOut() {
        do {
            try Auth.auth().signOut() // sign out on backend
            self.userSession = nil // sign out on frontend
            UserService.shared.currentUser = nil
        } catch {
            print("DEBUG: Failed to signout with error \(error.localizedDescription)")
        }
    }
    
    // populates data into database
    private func uploadUserData(email: String, userName: String, phoneNumber: String, id: String) async throws {
        let user = Users(uid: id, email: email, userName: userName, phoneNumber: phoneNumber)
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        try await Firestore.firestore().collection("users").document(id).setData(encodedUser)
    }
    
    // call it in login and createuser as well
    private func loadCurrentUserData() {
        Task { try await UserService.shared.fetchCurrentUser()}
    }
}
