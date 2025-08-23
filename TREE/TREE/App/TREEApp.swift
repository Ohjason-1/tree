//
//  TREEApp.swift
//  TREE
//
//  Created by Jaewon Oh on 5/16/25.
//

import SwiftUI
import FirebaseCore
import UserNotifications
import FirebaseMessaging
import GoogleSignIn
import FirebaseAuth

@main
struct TREEApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onOpenURL { url in
                    handleDeepLink(url: url)
                }
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { userActivity in
                    handleUniversalLink(userActivity: userActivity)
                }
        }
    }
    private func handleUniversalLink(userActivity: NSUserActivity) {
        guard userActivity.activityType == NSUserActivityTypeBrowsingWeb,
              let url = userActivity.webpageURL else {
            return
        }
        // Handle the new auth-complete path
        if url.path == "/auth-complete" {
            // Extract the original Firebase auth link from query parameters
            if let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
               let linkParam = components.queryItems?.first(where: { $0.name == "link" })?.value,
               let originalAuthURL = URL(string: linkParam) {
                
                if Auth.auth().isSignIn(withEmailLink: originalAuthURL.absoluteString) {
                    delegate.handleEmailLinkSignIn(url: originalAuthURL)
                } else {
                    print("🔴 Extracted URL is not a valid Firebase sign-in link")
                }
            } else {
                print("🔴 Could not extract original auth link from query parameters")
            }
            return
        }
        
        // Fallback: Handle direct Firebase auth links
        if Auth.auth().isSignIn(withEmailLink: url.absoluteString) {
            print("🟢 Direct Firebase auth link detected")
            delegate.handleEmailLinkSignIn(url: url)
        } else {
            print("🔴 NOT a valid Firebase sign-in link")
        }
    }
    private func handleDeepLink(url: URL) {
        print("Received custom URL: \(url)")
            // Handle Google Sign-In URLs only
            if GIDSignIn.sharedInstance.handle(url) {
                return
            }
            // Fallback for email links via custom scheme
            if Auth.auth().isSignIn(withEmailLink: url.absoluteString) {
                delegate.handleEmailLinkSignIn(url: url)
            }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if granted {
                    print("Notification authorization granted")
                } else {
                    print("Notification authorization denied")
                }
            }
            UNUserNotificationCenter.current().delegate = self
            Messaging.messaging().delegate = self
        }
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Auth.auth().setAPNSToken(deviceToken, type: .prod) // phone number verification
        
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("DEBUG: Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification notification: [AnyHashable : Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(notification) {
            completionHandler(.noData)
            return
        }
        // This notification is not auth related; it should be handled separately.
    }
    
    // MARK: - email auth
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("AppDelegate received URL: \(url)")
        
        // Handle Google Sign-In only
        if GIDSignIn.sharedInstance.handle(url) {
            return true
        }
        
        return false
    }
    
    func handleEmailLinkSignIn(url: URL) {
        guard let email = UserDefaults.standard.string(forKey: "PendingEmail"),
              let password = UserDefaults.standard.string(forKey: "PendingPassword"),
              let userName = UserDefaults.standard.string(forKey: "PendingUserName"),
              let phoneNumber = UserDefaults.standard.string(forKey: "PendingPhoneNumber"),
              let state = UserDefaults.standard.string(forKey: "PendingState"),
              let city = UserDefaults.standard.string(forKey: "PendingCity") else {
            print("Missing registration data for email link sign-in")
            return
        }
        // Sign in with email link
        Auth.auth().signIn(withEmail: email, link: url.absoluteString) { result, error in
            if let error = error {
                print("Email link sign-in failed: \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else {
                print("No user returned from email link sign-in")
                return
            }
            
            print("Email link sign-in succeeded for: \(user.email ?? "unknown")")
            
            Task {
                do {
                    try await user.updatePassword(to: password)
                    print("Password set successfully")
                    
                    // Save user profile data to Firestore
                    try await AuthService.shared.uploadUserData(
                        email: email,
                        userName: userName,
                        phoneNumber: phoneNumber,
                        id: user.uid,
                        state: state,
                        city: city
                    )
                    print("User data uploaded successfully")
                    await MainActor.run {
                        AuthService.shared.userSession = user
                    }
                    AuthService.shared.loadCurrentUserData()
                    self.clearRegistrationData()
                    
                    // Notify UI that registration is complete
                    await MainActor.run {
                        NotificationCenter.default.post(
                            name: .emailLinkSignInCompleted,
                            object: nil
                        )
                    }
                    
                } catch {
                    print("Failed to complete registration after email link sign-in: \(error.localizedDescription)")
                    
                    // Notify UI of error
                    await MainActor.run {
                        NotificationCenter.default.post(
                            name: .emailLinkSignInFailed,
                            object: nil,
                            userInfo: ["error": error.localizedDescription]
                        )
                    }
                }
            }
        }
    }
    
    private func clearRegistrationData() {
        UserDefaults.standard.removeObject(forKey: "PendingEmail")
        UserDefaults.standard.removeObject(forKey: "PendingPassword")
        UserDefaults.standard.removeObject(forKey: "PendingUserName")
        UserDefaults.standard.removeObject(forKey: "PendingPhoneNumber")
        UserDefaults.standard.removeObject(forKey: "PendingState")
        UserDefaults.standard.removeObject(forKey: "PendingCity")
        print("Registration data cleared")
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let emailLinkSignInCompleted = Notification.Name("emailLinkSignInCompleted")
    static let emailLinkSignInFailed = Notification.Name("emailLinkSignInFailed")
}

    
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping(UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            let userInfo = response.notification.request.content.userInfo
            
        NotificationCenter.default.post(
            name: .openChatFromNotification,
            object: nil,
            userInfo: userInfo
        )
            
            completionHandler()
        }
    }

extension AppDelegate: MessagingDelegate {
    @objc func messaging (_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("DEBUG: FCM Registration token: \(String(describing: fcmToken))")
        Task {
            try? await UserService.shared.updateFCMToken()
        }
    }
}
