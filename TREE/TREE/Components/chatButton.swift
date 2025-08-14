//
//  chatButton.swift
//  TREE
//
//  Created by Jaewon Oh on 8/13/25.
//

import SwiftUI

struct chatButton: View {
    let label: String
    var body: some View {
        Text("Chat with \(label) !")
            .font(.subheadline)
            .foregroundStyle(Color("AccentColor"))
            .fontWeight(.semibold)
            .frame(width: 360, height: 32)
            .foregroundStyle(Color(UIColor.label))
            .overlay {
                RoundedRectangle(cornerRadius: 6)
                    .stroke(Color("AccentColor"), lineWidth: 1)
            }
    }
}

#Preview {
    chatButton(label: "seller")
}
