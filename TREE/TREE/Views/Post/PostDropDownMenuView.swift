//
//  DropDownMenuPostView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/30/25.
//

import SwiftUI

struct PostDropDownMenuView: View {
    enum TreeType: String, CaseIterable {
        case sublets = "house.circle"
        case stores = "storefront.circle"
        
        var displayName: String {
            switch self {
            case .sublets: return "New Sublet"
            case .stores: return "New Store"
            }
        }
    }
    
    @Binding var selectedType: TreeType
    
    var body: some View {
        VStack {
            Menu {
                ForEach(TreeType.allCases, id: \.self) { type in
                    Button(action: {
                        selectedType = type
                    }) {
                        HStack {
                            Image(systemName: type.rawValue)
                            Text(type.displayName)
                            Spacer()
                        }
                    }
                }
            } label: {
                HStack {
                    HStack {
                        Text(selectedType.displayName)
                        Image(systemName: "chevron.down")
                    }
                    .fontWeight(.semibold)
                }
                .foregroundColor(Color(UIColor.label))
            }
        }
        
    }
}

#Preview {
    PostDropDownMenuView(selectedType: .constant(.sublets))
}
