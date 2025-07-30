//
//  ChatCellView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/17/25.
//

import SwiftUI

struct ChatCellView: View {
    let message: Messages
    let user: Users
    
    var body: some View {
        HStack {
            if message.isFromCurrentUser {
                Spacer()
                
                Text(message.messageText)
                    .font(.subheadline)
                    .padding(12)
                    .background(Color("AccentColor"))
                    .foregroundStyle(.white)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: 10,
                            bottomLeadingRadius: 10,
                            bottomTrailingRadius: 0,
                            topTrailingRadius: 10
                        )
                    )
            } else {
                HStack(alignment: .bottom, spacing: 8) {
                    CircularProfileImageView(userImageUrl: user.userImageUrl, size: .xSmall)
                    
                    Text(message.messageText)
                        .font(.subheadline)
                        .padding(12)
                        .background(Color("Color").opacity(0.6))
                        .foregroundStyle(.primary)
                        .clipShape(
                            UnevenRoundedRectangle(
                                topLeadingRadius: 10,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 10,
                                topTrailingRadius: 10
                            )
                        )
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 8)
    }
}

#Preview {
    ChatCellView(message: DeveloperPreview.shared.message, user: DeveloperPreview.shared.user)
}
