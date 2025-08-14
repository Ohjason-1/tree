//
//  ProfileElementView.swift
//  TREE
//
//  Created by Jaewon Oh on 8/13/25.
//

import SwiftUI
import Kingfisher

struct ProfileElementView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    let tree: any Tree
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            KFImage(URL(string: tree.imageURLs[0]))
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(.circle)
                
            
            VStack(alignment: .leading, spacing: 4) {
                Text(tree.title)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(tree.description)
                    .font(.subheadline)
                    .lineLimit(2)
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            }
            
            HStack {
                // if tree is sublet -> subletlistingdetailview
                Text(tree.timeStamp.dateValue().dateString())
                
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

private extension ProfileElementView {
    func onDelete() {
        Task { await viewModel.deleteTreeFeed(tree) }
    }
}

#Preview {
    ProfileElementView(tree: DeveloperPreview.shared.sublets[0])
}
