//
//  BoxRow.swift
//  TREE
//
//  Created by Jaewon Oh on 7/15/25.
//

import SwiftUI

struct MessageRowView: View {
    @EnvironmentObject var viewModel: MessagesViewModel
    
    let message: Messages
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            CircularProfileImageView(user: message.user ?? Users(uid: "", email: "", userName: "", phoneNumber: ""), size: .small)
                
            // username
            VStack(alignment: .leading, spacing: 4) {
                Text(message.user?.userName ?? "unknown boy")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(message.messageText)
                    .font(.subheadline)
                    .lineLimit(2)
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            }
            
            VStack(alignment: .trailing) {
                HStack {
                    Text(message.timestampString)
                    
                    Image(systemName: "chevron.right")
                }
                .foregroundStyle(.secondary)
                
                if message.badge > 0 {
                    Text("\(message.badge)")
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Capsule().fill(.red.opacity(0.8)))
                        
                }
            }
            .font(.footnote)
        }
        .frame(height: 64)
        .swipeActions {
            Button {
                onDelete()
            } label: {
                Image(systemName: "trash")
            }
            .tint(Color(.systemRed))
        }
        
    }
}

private extension MessageRowView {
    func onDelete() {
        Task { await viewModel.deleteRecentMessage(message)}
    }
}

#Preview {
    MessageRowView(message: DeveloperPreview.shared.message)
}
