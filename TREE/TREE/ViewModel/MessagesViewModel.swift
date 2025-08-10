//
//  MessagesViewModel.swift
//  TREE
//
//  Created by Jaewon Oh on 7/17/25.
//

import Foundation
import FirebaseFirestore
import Combine
import UserNotifications

class MessagesViewModel: ObservableObject {
    @Published var recentMessages = [Messages]()
    
    private var cancellables = Set<AnyCancellable>()
    private let service = MessagesService()
    private var didCompleteInitialLoad = false
    private let notificationManager = NotificationManager.shared
    
    init() {
        setupMessages()
        service.observeRecentMessages()
        requestNotificationPermission()
    }
    
    func deleteRecentMessage(_ message: Messages) async {
        do {
            guard let index = self.recentMessages.firstIndex(where: { $0.id == message.id }) else { return }
            recentMessages.remove(at: index)
            try await service.deleteConversation(recentMessage: message)
        } catch {
            print("DEBUG: Failed to delete message \(error.localizedDescription)")
        }
    }
    
    private func setupMessages() {
        service.$documentChanges.sink { [weak self] changes in
            guard let self else { return }
            if didCompleteInitialLoad {
                updateMessages(changes)
            } else {
                loadInitialMessages(fromChanges: changes)
            }
        }.store(in: &cancellables)
    }
    
    private func loadInitialMessages(fromChanges changes: [DocumentChange]) {
        let messages = changes.compactMap({ try? $0.document.data(as: Messages.self )})
        for message in messages {
            self.recentMessages.append(message)
            UserService.fetchUser(withUid: message.chatPartnerId) { [weak self] user in
                guard let self else { return }
                if let index = self.recentMessages.firstIndex(where: { $0.id == message.id }) {
                    self.recentMessages[index].user = user
                }
            }
        }
        self.didCompleteInitialLoad = true
        
    }
    
    private func updateMessages(_ changes: [DocumentChange]) {
        for change in changes {
            if change.type == .added {
                createNewConversation(change)
            } else if change.type == .modified {
                updateMessagesFromExistingConversation(change)
            }
        }
    }
    
    // add new message inbox at index 0
    private func createNewConversation(_ change: DocumentChange) {
        guard var message = try? change.document.data(as: Messages.self) else { return }
        UserService.fetchUser(withUid: message.chatPartnerId) { [weak self] user in
            message.user = user
            self?.recentMessages.insert(message, at: 0)
            
            self?.sendNewMessageNotification(message: message, user: user)
        }
    }
    
    // find message inbox from the recent messages, remove it, and update it, place it at index 0
    private func updateMessagesFromExistingConversation(_ change: DocumentChange) {
        guard var message = try? change.document.data(as: Messages.self) else { return }
        guard let index = self.recentMessages.firstIndex(where: { $0.user?.id == message.chatPartnerId }) else { return }
        let previousText = recentMessages[index]
        message.user = recentMessages[index].user
        
        recentMessages.remove(at: index)
        recentMessages.insert(message, at: 0)
        
        if previousText != message {
            sendNewMessageNotification(message: message, user: message.user)
        }
    }
    
    // MARK: - Notification Methods
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification Permission Granted")
            } else if let error = error {
                print("DEBUG: Error requesting notification permission \(error.localizedDescription)")
            }
        }
    }
    
    private func sendNewMessageNotification(message: Messages, user: Users?) {
        guard let user = user else { return }
        let content = UNMutableNotificationContent()
        content.title = user.userName
        content.body = message.messageText
        content.sound = .default
        content.badge = NSNumber(value: getUnreadMessageCount())
        content.userInfo = [
            "userId": message.chatPartnerId,
            "messageId": message.id
        ]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let request = UNNotificationRequest(
            identifier: message.id,
            content: content,
            trigger: trigger
        )
                
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("DEBUG: Error sending notification: \(error.localizedDescription)")
            }
        }
    }
    
    private func getUnreadMessageCount() -> Int {
        return recentMessages.filter { $0.unread }.count
        }
}


// MARK: - Notification Manager
class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {}
    
    func handleNotificationResponse(_ response: UNNotificationResponse) {
        let userInfo = response.notification.request.content.userInfo
        if let userId = userInfo["userId"] as? String {
            NotificationCenter.default.post(
                name: .openChatFromNotification,
                object: nil,
                userInfo: ["userId": userId]
            )
        }
    }
    
    func clearBadgeCount() {
        UNUserNotificationCenter.current().setBadgeCount(0) { error in
            if let error = error {
                print("DEBUG: Error clearing badge: \(error.localizedDescription)")
            }
        }
    }
}

extension Notification.Name {
    static let openChatFromNotification = Notification.Name("openChatFromNotification")
}
