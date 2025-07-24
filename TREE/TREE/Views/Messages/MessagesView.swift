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
                
                ForEach(viewModel.recentMessages) { message in
                    ZStack {
                        NavigationLink {
                            ChatView(user: message.user!)
                        } label: {
                            EmptyView()
                        }
                        .opacity(0.0)
                        MessageRowView(viewModel: viewModel, message: message)
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
