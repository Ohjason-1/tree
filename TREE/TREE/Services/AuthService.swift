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
import FirebaseMessaging

class AuthService {
    
    @Published var userSession: FirebaseAuth.User?
    
    static let shared = AuthService() // without this, we have multiple of usersession.
    
    // only called when first auth initialization, after killing the app.
    init() {
        self.userSession = Auth.auth().currentUser
        UserInfo.currentUserId = self.userSession?.uid ?? ""
        loadCurrentUserData()
        print("starting authservice")
    }
    
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            print("logging in")
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
    @MainActor func signOut() {
        Task {
            await removeCurrentDeviceTokenFromUser()   
            do {
                try Auth.auth().signOut()
                self.userSession = nil
                ViewModelManager.shared.userSession = nil
            } catch {
                print("DEBUG: Failed to signout with error \(error.localizedDescription)")
            }
        }
    }
    
    private func removeCurrentDeviceTokenFromUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if let token = try? await Messaging.messaging().token() {
            do {
                try await Firestore.firestore().collection("users").document(uid).updateData([
                    "fcmToken": FieldValue.arrayRemove([token])
                ])
            } catch {
                print("DEBUG: Failed to remove FCM token on signout: \(error.localizedDescription)")
            }
        }
    }
    
    // populates data into database
    private func uploadUserData(email: String, userName: String, phoneNumber: String, id: String) async throws {
        let fcmToken = try await Messaging.messaging().token()
        let user = Users(
            uid: id,
            email: email,
            userName: userName,
            phoneNumber: phoneNumber,
            fcmToken: [fcmToken]
        )
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        try await Firestore.firestore().collection("users").document(id).setData(encodedUser)
    }
    
    // call it in login and createuser as well
    private func loadCurrentUserData() {
        Task {
            try await UserService.shared.fetchCurrentUser()
            try await UserService.shared.updateFCMToken()
        }
    }
}
