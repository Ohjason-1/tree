//
//  ChatView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/17/25.
//

import SwiftUI

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel
    let user: Users
    let messageViewModel = ViewModelManager.shared.messagesViewModel
    @Binding var shouldNavigateToChat: Bool
    
    init(user: Users, shouldNavigateToChat: Binding<Bool> = .constant(false)) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
        self._shouldNavigateToChat = shouldNavigateToChat
    }
    
    var body: some View {
        VStack {
            if shouldNavigateToChat {
                Button {
                    shouldNavigateToChat = false
                } label: {
                    HStack() {
                        Image(systemName: "chevron.left")
                        Text("Back")
                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
            
            ScrollViewReader { proxy in
                ScrollView {
                    VStack {
                        CircularProfileImageView(user: user, size: .medium)
                        
                        VStack(spacing: 4) {
                            Text(user.userName)
                                .font(.title3)
                                .fontWeight(.semibold)
                            
                            Text("TREE")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.bottom)
                    .id("top")
                    
                    ForEach(viewModel.messages) { message in
                        ChatCellView(message: message, user: user)
                            .id(message.id)
                    }
                    
                    // Invisible anchor at the bottom
                    Color.clear
                        .frame(height: 1)
                        .id("bottom")
                }
                .defaultScrollAnchor(.bottom)
                .onAppear {
                    
                    // Mark message as read
                    Task {
                        if let index = messageViewModel.recentMessages.firstIndex(where: { $0.user?.id == user.id }) {
                            messageViewModel.recentMessages[index].badge = 0
                            messageViewModel.updateBadgeCount()
                            await messageViewModel.markMessageAsRead(messageId: messageViewModel.recentMessages[index].id)
                        }
                    }
                }
                .onChange(of: viewModel.messages.count) {
                    // Scroll to bottom when new messages are added
                    DispatchQueue.main.async {
                        withAnimation(.easeOut(duration: 0.3)) {
                            proxy.scrollTo("bottom", anchor: .bottom)
                        }
                    }
                }
            }
            
            Spacer()
            
            ZStack(alignment: .trailing) {
                TextField("Enter a message", text: $viewModel.messageText, axis: .vertical)
                    .padding(12)
                    .padding(.trailing, 48)
                    .background(Color(.systemGroupedBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .font(.subheadline)
                    .autocorrectionDisabled(true)
                
                Button {
                    viewModel.sendMessage()
                    viewModel.messageText = ""
                } label: {
                    Text("Send")
                        .fontWeight(.semibold)
                }
                .padding(.horizontal)
            }
            .padding()
        }
    }
}

#Preview {
    ChatView(user: Users(uid: NSUUID().uuidString, email: "oho@gmail.com", userName: "Dog", phoneNumber: "1232142", userImageUrl: "Profile"))
}
