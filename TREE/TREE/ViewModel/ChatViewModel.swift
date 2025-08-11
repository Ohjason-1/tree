//
//  ChatViewModel.swift
//  TREE
//
//  Created by Jaewon Oh on 7/18/25.
//

import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages = [Messages]()
    @Published var messageText = ""
    let service: ChatService
    
    init(user: Users) {
        self.service = ChatService(chatPartner: user)
        observeMessages()
    }
    
    func observeMessages() {
        service.observeMessages() { message in
            self.messages.append(contentsOf: message)
        }
    }
    
    func sendMessage() {
        service.sendMessage(messageText)
    }
    
}
