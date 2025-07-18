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
            VStack(spacing: 20) {
                HStack {
                    Image("Messages")
                        .resizable()
                        .frame(width: 140, height: 28)
                        .padding(.top, 108)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                List {
                    
                    ForEach(viewModel.users) { user in
                        NavigationLink {
                            ChatView(user: user)
                        } label: {
                            MessageRowView(user: user)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .frame(height: UIScreen.main.bounds.height - 120)
            }
            
        
            
        }
    }
}

#Preview {
    MessagesView()
}
