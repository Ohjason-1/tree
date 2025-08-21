//
//  DropDownPostView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/29/25.
//

import SwiftUI

struct DropDownPost: View {
    var menus: [String]
    @Binding var selected: String
    let wantBlack: Bool
    
    var body: some View {
        VStack {
            Menu {
                ForEach(menus, id: \.self) { menu in
                    Button(action: {
                        selected = menu
                    }) {
                        HStack {
                            Text(menu)
                            Spacer()
                        }
                    }
                }
            } label: {
                HStack {
                    Spacer()
                    Text(selected)
                        .font(.headline)
                        .fontWeight(.semibold)
                    Spacer()
                    Image(systemName: "chevron.down")
                        .padding(.trailing)
                }
                .foregroundColor(wantBlack ? .black : Color(UIColor.label))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color("Color").gradient, lineWidth: 2)
        )
    }
}

#Preview {
    DropDownPost(menus: ["a", "b"], selected: .constant("Hello World"), wantBlack: false)
}
