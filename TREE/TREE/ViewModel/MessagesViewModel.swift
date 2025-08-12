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

struct RecentMessage {
    var message: Messages
    var unread: Bool
}

class MessagesViewModel: ObservableObject {
    @Published var recentMessages = [RecentMessage]() // (recent message, unread)
    
    private var cancellables = Set<AnyCancellable>()
    private let service = MessagesService()
    private var didCompleteInitialLoad = false
    private let notificationManager = NotificationManager.shared
    
    init() {
        setupMessages()
        service.observeRecentMessages()
    }
    
    func deleteRecentMessage(_ message: Messages) async {
        do {
            guard let index = self.recentMessages.firstIndex(where: { $0.message.id == message.id }) else { return }
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
        var loadedCount = 0
        let totalCount = messages.count
        for message in messages {
            self.recentMessages.append(RecentMessage(message: message, unread: true))
            UserService.fetchUser(withUid: message.chatPartnerId) { [weak self] user in
                guard let self else { return }
                if let index = self.recentMessages.firstIndex(where: { $0.message.id == message.id }) {
                    self.recentMessages[index].message.user = user
                }
                loadedCount += 1
                if loadedCount == totalCount {
                    self.didCompleteInitialLoad = true
                    
                }
            }
        }
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
            self?.recentMessages.insert(RecentMessage(message: message, unread: true), at: 0)
            
            self?.sendNewMessageNotification(message: message)
        }
    }
    
    // find message inbox from the recent messages, remove it, and update it, place it at index 0
    private func updateMessagesFromExistingConversation(_ change: DocumentChange) {
        guard var message = try? change.document.data(as: Messages.self) else { return }
        guard let index = self.recentMessages.firstIndex(where: { $0.message.user?.id == message.chatPartnerId }) else { return }
        message.user = recentMessages[index].message.user
        print("update")
        recentMessages.remove(at: index)
        recentMessages.insert(RecentMessage(message: message, unread: true), at: 0)
        
        sendNewMessageNotification(message: message)
    }
    
    // MARK: - Notification Methods
    
    private func sendNewMessageNotification(message: Messages) {
        guard let user = UserService().currentUser else { return }
        let content = UNMutableNotificationContent()
        content.title = user.userName
        content.body = message.messageText
        content.sound = .default
        content.badge = NSNumber(value: getUnreadMessageCount())
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
    
    private func getUnreadMessageCount() -> Int {
        return recentMessages.filter { $0.unread }.count
    }
    
    func markMessageAsRead(messageId: String) {
        if let index = recentMessages.firstIndex(where: { $0.message.id == messageId }) {
            recentMessages[index].unread = false
            updateBadgeCount() // Update badge after marking as read
        }
    }
    
    private func updateBadgeCount() {
        let unreadCount = getUnreadMessageCount()
        DispatchQueue.main.async {
            UNUserNotificationCenter.current().setBadgeCount(unreadCount) { error in
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
