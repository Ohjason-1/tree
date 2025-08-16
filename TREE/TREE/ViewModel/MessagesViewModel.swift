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
import FirebaseAuth



@MainActor
class MessagesViewModel: ObservableObject {
    @Published var recentMessages = [Messages]() { didSet { updateBadgeCount() } }
    @Published var badgeCount = 0
    @Published var read: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private let service = MessagesService()
    private let notificationManager = NotificationManager.shared
    
    init() {
        service.observeRecentMessages()
        setupMessages()
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
            updateMessages(changes)
        }.store(in: &cancellables)
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
        guard let message = try? change.document.data(as: Messages.self) else { return }
        guard !recentMessages.contains(where: { $0.id == message.id }) else { return }
        self.recentMessages.append(message)
        print(self.recentMessages)
        UserService.fetchUser(withUid: message.chatPartnerId) { [weak self] user in
            guard let self else { return }
            DispatchQueue.main.async {
                if let idx = self.recentMessages.firstIndex(where: { $0.id == message.id }) {
                    self.recentMessages[idx].user = user
                    if !self.recentMessages[idx].isFromCurrentUser {
                        self.sendNewMessageNotification(message: message)
                    } else {
                        self.recentMessages[idx].badge = 0
                    }
                }
            }
        }
        
    }
    
    // find message inbox from the recent messages, remove it, and update it, place it at index 0
    private func updateMessagesFromExistingConversation(_ change: DocumentChange) {
        guard var message = try? change.document.data(as: Messages.self) else { return }
        guard let index = self.recentMessages.firstIndex(where: { $0.id == message.id }) else { return }
        if read {
            read = false
            return
        }
        DispatchQueue.main.async {
            let isIncoming = !message.isFromCurrentUser
            message.user = self.recentMessages[index].user
            // Only send notification if the message was from other user
            print("isIncoming: \(isIncoming)")
            if isIncoming {
                message.badge = self.recentMessages[index].badge + 1
                self.sendNewMessageNotification(message: message)
            } else {
                message.badge = 0
            }
            self.recentMessages.removeAll { $0.id == message.id }
            self.recentMessages.insert(message, at: 0)
        }
    }
    
    // MARK: - Notification Methods
    
    private func sendNewMessageNotification(message: Messages) {
        guard let user = UserService().currentUser else { return }
        let content = UNMutableNotificationContent()
        content.title = message.user?.userName ?? "New Message"
        content.body = message.messageText
        content.sound = .default
        content.badge = NSNumber(value: 1)
        content.userInfo = [
            "userId": user.id,
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
    
    private func getUnreadMessageCount() {
        badgeCount = recentMessages.reduce(0) { $0 + $1.badge }
        //print("count of unread \(badgeCount)")
    }
    @MainActor
    func markMessageAsRead(messageId: String) async {
        if let index = recentMessages.firstIndex(where: { $0.id == messageId }) {
            do {
                read = true
                try await service.markMessageAsRead(message: recentMessages[index])
            } catch {
                // If Firebase update fails, revert the local changes
                print("Failed to update message in Firebase: \(error)")
            }
             // Update badge after marking as read
        }
    }
    
    func updateBadgeCount() {
        getUnreadMessageCount()
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().setBadgeCount(self.badgeCount) { error in
                if let error = error {
                    print("DEBUG: Error updating badge count: \(error.localizedDescription)")
                }
            }
        }
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
