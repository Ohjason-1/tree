//
//  Boxes.swift
//  TREE
//
//  Created by Jaewon Oh on 7/15/25.
//

import SwiftUI

struct MessagesView: View {
    @StateObject var viewModel = MessagesViewModel()
    
    // list of all users; fix it
    var body: some View {
        NavigationStack {
            List {
                HStack {
                    Image("Messages")
                        .resizable()
                        .frame(width: 140, height: 28)
                    
                    Spacer()
                }
                .listRowSeparator(.hidden)
                .padding(.vertical, 12)
                
                ForEach(viewModel.recentMessages, id: \.message.id) { recentMessage in
                    if let user = recentMessage.message.user {
                        ZStack {
                            NavigationLink {
                                ChatView(user: user)
                                    .onTapGesture {
                                        if let index = viewModel.recentMessages.firstIndex(where: { recentMessage.message.id == $0.message.id }) {
                                            viewModel.recentMessages[index].unread = false
                                        }
                                    }
                            } label: {
                                EmptyView()
                            }
                            .opacity(0.0)
                            MessageRowView(viewModel: viewModel, message: recentMessage.message)
                        }
                    }
                }
            }
            .listStyle(PlainListStyle())
        }
    }
}

#Preview {
    MessagesView()
}
