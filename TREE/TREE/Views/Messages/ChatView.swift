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
    
    init(user: Users) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: ChatViewModel(user: user))
    }
    
    var body: some View {
        
        VStack {
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
                
                ForEach(viewModel.messages) { message in
                    ChatCellView(message: message, user: user)
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
