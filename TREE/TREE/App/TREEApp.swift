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
        UNUserNotificationCenter.current().delegate = self
        application.registerForRemoteNotifications() // register for remote notifications
        Messaging.messaging().delegate = self  // set messaging delegate for FCM
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        //let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        //print("Device Token: \(token)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("DEBUG: Failed to register for remote notifications: \(error.localizedDescription)")
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping(UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    
    
}

extension AppDelegate: MessagingDelegate {
    func messaging (_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("DEBUG: FCM Registration token: \(fcmToken ?? "")")
        
        
    }
}
