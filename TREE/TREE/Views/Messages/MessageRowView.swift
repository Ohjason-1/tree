//
//  BoxRow.swift
//  TREE
//
//  Created by Jaewon Oh on 7/15/25.
//

import SwiftUI

struct MessageRowView: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image("Profile")
                .resizable()
                .scaledToFill()
                .frame(width: 56, height: 56)
                .clipShape(.circle)
                
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Dragon Fighter")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("Can I book a tour on August 2nd?")
                    .font(.subheadline)
                    .lineLimit(2)
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            }
            
            HStack {
                Text("Yesterday")
                
                Image(systemName: "chevron.right")
            }
            .font(.footnote)
            .foregroundStyle(Color(.gray))
        }
        .frame(height: 64)
        
    }
}

#Preview {
    MessageRowView()
}
