//
//  DropDownMenuTreeView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/29/25.
//

import SwiftUI

struct DropDownMenuTreeView: View {
    enum TreeType: String, CaseIterable {
        case sublets = "house.circle"
        case stores = "storefront.circle"
        var displayName: String {
            switch self {
            case .sublets: return "Sublets"
            case .stores: return "Stores"
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
                    Image(systemName: selectedType.rawValue)
                        .font(.title3)
                    
                    Image(systemName: "chevron.up.chevron.down")
                }
                .foregroundColor(Color(UIColor.label))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(width: 65, height: 35)
        .background(Color(.systemGray2).gradient)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


#Preview {
    DropDownMenuTreeView(selectedType: .constant(.sublets))
}
