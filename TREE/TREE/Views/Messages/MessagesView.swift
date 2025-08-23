//
//  Boxes.swift
//  TREE
//
//  Created by Jaewon Oh on 7/15/25.
//

import SwiftUI

struct MessagesView: View {
    @EnvironmentObject var viewModel: MessagesViewModel
    @State var selectedUser: Users?
    
    // list of all users; fix it
    var body: some View {
        NavigationStack {
            List {
               Text("Messages")
                .font(.system(size: 36, weight: .black, design: .rounded))
                .fontDesign(.rounded)
                .foregroundStyle(Color("AccentColor").gradient)
                .listRowSeparator(.hidden)
                .padding(.vertical, 12)
                
                ForEach(viewModel.recentMessages) { recentMessage in
                    Button(action: {
                        selectedUser = recentMessage.user
                    }) {
                        MessageRowView(message: recentMessage)
                    }
                }
            }
            .navigationDestination(item: $selectedUser) { user in
                ChatView(user: user)
                    .toolbar(.hidden, for: .tabBar)
            }
            .listStyle(PlainListStyle())
        }
    }
}

#Preview {
    MessagesView()
}
