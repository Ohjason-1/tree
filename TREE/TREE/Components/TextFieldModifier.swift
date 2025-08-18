//
//  TextFieldModifier.swift
//  TREE
//
//  Created by Jaewon Oh on 7/15/25.
//

import SwiftUI

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .padding(12)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 24)
            .autocorrectionDisabled()
    }
}

struct PostModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.subheadline)
            .autocorrectionDisabled()
            .frame(height: 48)
            .padding(.horizontal, 16)
            .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color("Color").gradient, lineWidth: 2)
                )
    }
}

