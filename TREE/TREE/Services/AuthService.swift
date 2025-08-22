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
    @Published var errorMessage: String = ""
    
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
            errorMessage = "Failed to login. Please check your email and password."
            throw error
        }
    }
    
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
    func uploadUserData(email: String, userName: String, phoneNumber: String, id: String, state: String, city: String) async throws {
        let fcmToken = try await Messaging.messaging().token()
        let user = Users(
            uid: id,
            email: email,
            userName: userName,
            phoneNumber: phoneNumber,
            fcmToken: [fcmToken],
            state: state,
            city: city
        )
        guard let encodedUser = try? Firestore.Encoder().encode(user) else { return }
        try await Firestore.firestore().collection("users").document(id).setData(encodedUser)
    }
    
    // call it in login and createuser as well
    func loadCurrentUserData() {
        Task {
            try await UserService.shared.fetchCurrentUser()
            try await UserService.shared.updateFCMToken()
        }
    }
    
}

// MARK: - Sign In Email
extension AuthService {
    @MainActor
    func createUser(withEmail email: String, password: String, userName: String, phoneNumber: String, state: String, city: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            try await self.uploadUserData(email: email, userName: userName, phoneNumber: phoneNumber, id: result.user.uid, state: state, city: city)
            loadCurrentUserData()
        } catch {
            errorMessage = "Failed to create account"
            print("DEBUG: failed to create user with error \(error.localizedDescription)")
            throw error
        }
    }
    
    func sendSignInLink(email: String) async throws {
        let actionCodeSettings = ActionCodeSettings()
        actionCodeSettings.handleCodeInApp = true
        actionCodeSettings.url = URL(string: "https://tree-50227.web.app")
        actionCodeSettings.setIOSBundleID(Bundle.main.bundleIdentifier!)
        do {
            try await Auth.auth().sendSignInLink(toEmail: email, actionCodeSettings: actionCodeSettings)
            print("Sign-in link sent to \(email)")
        } catch {
            errorMessage = "Failed to send sign-in link: \(error.localizedDescription)"
            throw error
        }
    }
    
    func setPassword(_ password: String) async throws {
        guard let user = Auth.auth().currentUser else {
            throw AuthError.noCurrentUser
        }
        do {
            try await user.updatePassword(to: password)
            print("Password set successfully")
        } catch {
            errorMessage = "Failed to set password: \(error.localizedDescription)"
            throw error
        }
    }
    func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            throw error
        }
    }
    
}

// MARK: - Sign In SSO

extension AuthService {
    func signInWithGoogle(userName: String, phoneNumber: String, state: String, city: String, password: String, credential: AuthCredential) async throws {
        do {
            let AuthDataResult = try await Auth.auth().signIn(with: credential)
            try await setPassword(password)
            try await self.uploadUserData(email: AuthDataResult.user.email!, userName: userName, phoneNumber: phoneNumber, id: AuthDataResult.user.uid, state: state, city: city)
            loadCurrentUserData()
            self.userSession = AuthDataResult.user
        } catch {
            throw AuthError.signInFailed(error.localizedDescription)
        }
    }
}


enum AuthError: Error {
    case missingEmail
    case emailNotVerified
    case signInFailed(String)
    case noCurrentUser
}
