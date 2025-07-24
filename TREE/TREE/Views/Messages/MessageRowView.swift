//
//  BoxRow.swift
//  TREE
//
//  Created by Jaewon Oh on 7/15/25.
//

import SwiftUI

struct MessageRowView: View {
    @ObservedObject var viewModel: MessagesViewModel
    
    let message: Messages
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            CircularProfileImageView(user: message.user, size: .small)
                
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
            
            HStack {
                Text(message.timestampString)
                
                Image(systemName: "chevron.right")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
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
    MessageRowView(viewModel: MessagesViewModel(), message: DeveloperPreview.shared.message)
}
