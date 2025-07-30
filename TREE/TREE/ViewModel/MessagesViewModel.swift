//
//  MessagesViewModel.swift
//  TREE
//
//  Created by Jaewon Oh on 7/17/25.
//

import Foundation
import FirebaseFirestore
import Combine

class MessagesViewModel: ObservableObject {
    @Published var recentMessages = [Messages]()
    
    private var cancellables = Set<AnyCancellable>()
    private let service = MessagesService()
    private var didCompleteInitialLoad = false
    
    init() {
        setupMessages()
        service.observeRecentMessages()
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
        var messages = changes.compactMap({ try? $0.document.data(as: Messages.self )})
        
        for i in 0..<messages.count {
            let message = messages[i]
            
            UserService.fetchUser(withUid: message.chatPartnerId) { user in
                messages[i].user = user
                self.recentMessages.append(messages[i])
                
                self.recentMessages.sort { $0.timeStamp.dateValue() > $1.timeStamp.dateValue() }
                if i == messages.count - 1 {
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
            self?.recentMessages.insert(message, at: 0)
        }
    }
    
    // find message inbox from the recent messages, remove it, and update it, place it at index 0
    private func updateMessagesFromExistingConversation(_ change: DocumentChange) {
        guard var message = try? change.document.data(as: Messages.self) else { return }
        guard let index = self.recentMessages.firstIndex(where: { $0.user?.id == message.chatPartnerId }) else { return }
        
        message.user = recentMessages[index].user
        
        recentMessages.remove(at: index)
        recentMessages.insert(message, at: 0)
    }
}
