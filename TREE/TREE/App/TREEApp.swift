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

@main
struct TREEApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification authorization granted")
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                        UNUserNotificationCenter.current().delegate = self
                }
            } else {
                print("Notification authorization denied")
            }
        }
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("DEBUG: Failed to register for remote notifications: \(error.localizedDescription)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping(UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            let userInfo = response.notification.request.content.userInfo
            
            if let userId = userInfo["userId"] as? String {
                // Navigate to chat with this user
                NotificationCenter.default.post(
                    name: .openChatFromNotification,
                    object: nil,
                    userInfo: ["userId": userId]
                )
            }
            
            completionHandler()
        }
}

extension AppDelegate: MessagingDelegate {
    func messaging (_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("DEBUG: FCM Registration token: \(fcmToken ?? "")")
        Task {
            try? await UserService.shared.updateFCMToken()
        }
    }
}
