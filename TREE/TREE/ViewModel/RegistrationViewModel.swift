//
//  RegistrationViewModel.swift
//  TREE
//
//  Created by Jaewon Oh on 7/17/25.
//

import Foundation
import FirebaseCore
import GoogleSignIn
import FirebaseAuth

class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var userName = ""
    @Published var phoneNumber = ""
    @Published var state = ""
    @Published var city = ""
    @Published var errorMessage = ""
    @Published var verificationCode = ""
    @Published var isLoading = false
    @Published var verificationID: String?
    @Published var isVerified = false
    @Published var showAlert = false
    @Published var emailSent = false
    
    @Published var accountCreated = false
    @Published var emailVerified = false
    
    init() { setupEmailLinkListeners() }
    deinit { NotificationCenter.default.removeObserver(self) }
    func createUser() async throws {
        do {
            try await AuthService.shared.createUser(withEmail: email, password: password, userName: userName, phoneNumber: phoneNumber, state: state, city: city)
        } catch {
            errorMessage = AuthService.shared.errorMessage
            throw error
        }
    }
    
    // MARK: - google sign in
    func signIngoogle() async throws {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        guard let topVC = await GoogleSingInViewController.shared.topViewController() else { throw URLError(.cannotFindHost) }
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        guard let idToken = gidSignInResult.user.idToken?.tokenString else { throw URLError(.badServerResponse) }
        let accessToken = gidSignInResult.user.accessToken.tokenString
        let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                       accessToken: accessToken)
        try await AuthService.shared.signInWithGoogle(userName: userName, phoneNumber: phoneNumber, state: state, city: city, password: password, credential: credential)
    }
    
    func sendRegistrationEmailLink() async throws {
        await MainActor.run { isLoading = true }
        do {
            UserDefaults.standard.set(email, forKey: "PendingEmail")
            UserDefaults.standard.set(password, forKey: "PendingPassword")
            UserDefaults.standard.set(userName, forKey: "PendingUserName")
            UserDefaults.standard.set(phoneNumber, forKey: "PendingPhoneNumber")
            UserDefaults.standard.set(state, forKey: "PendingState")
            UserDefaults.standard.set(city, forKey: "PendingCity")
            try await AuthService.shared.sendSignInLink(email: email)
            await MainActor.run {
                emailSent = true
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = AuthService.shared.errorMessage
                emailSent = false
                showAlert = true
                isLoading = false
            }
            throw error
        }
    }

    // Listen for completion
    func setupEmailLinkListeners() {
        NotificationCenter.default.addObserver(
            forName: .emailLinkSignInCompleted,
            object: nil,
            queue: .main
        ) { _ in
            self.accountCreated = true
            self.emailVerified = true
        }
        NotificationCenter.default.addObserver(
            forName: .emailLinkSignInFailed,
            object: nil,
            queue: .main
        ) { notification in
            if let error = notification.userInfo?["error"] as? String {
                self.errorMessage = error
                self.showAlert = true
            }
        }
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    // MARK: - Phone number verification
    func sendVerificationCode(to phoneNumber: String) async throws {
        await MainActor.run { isLoading = true; errorMessage = "" }
        do {
            let verificationID = try await PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil)
            await MainActor.run { self.verificationID = verificationID; self.isLoading = false }
            print("Verification code sent to \(phoneNumber)")
        } catch {
            await MainActor.run {
                self.errorMessage = "Failed to send verification code: \(error.localizedDescription)"
                self.isLoading = false
                self.showAlert = true
            }
            throw error
        }
    }
    
    func verifyCode(_ code: String) async throws -> Bool {
        guard let verificationID = verificationID else {
            self.errorMessage = "No verificationID"
            return false
        }
        await MainActor.run { isLoading = true; errorMessage = "" }
        do {
            let credential = PhoneAuthProvider.provider().credential(
                withVerificationID: verificationID,
                verificationCode: code
            )
            let result = try await Auth.auth().signIn(with: credential)
            try await result.user.delete()
            await MainActor.run {
                self.isVerified = true
                self.isLoading = false
                
            }
            print("Phone number verified successfully")
            return true
        } catch {
            await MainActor.run {
                self.errorMessage = "Invalid verification code: \(error.localizedDescription)"
                self.isLoading = false
                self.showAlert = true
            }
            throw error
        }
    }
    
    // Reset verification state
    func reset() {
        email = ""
        password = ""
        userName = ""
        phoneNumber = ""
        state = ""
        city = ""
        errorMessage = ""
        verificationCode = ""
        isLoading = false
        verificationID = nil
        isVerified = false
        showAlert = false
    }
    
    func resetVerification() {
        verificationCode = ""
        isLoading = false
        verificationID = nil
        isVerified = false
        showAlert = false
    }
}
