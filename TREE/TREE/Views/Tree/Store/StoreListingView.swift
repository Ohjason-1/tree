//
//  StoreListingView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/16/25.
//

import SwiftUI

struct StoreListingView: View {
    let store: Stores
    
    var body: some View {
        ZStack {
            Color(.gray).opacity(0.05)
            
            HStack(alignment: .top, spacing: 16) {
                // images
                TreeListingModifier(tree: store)
                    .frame(width: 120, height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(.systemGray6), lineWidth: 0.5)
                    }
                
                VStack(alignment: .leading) {
                    Text("\(store.title)")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("$\(store.price)")
                            .font(.headline)
                            .fontWeight(.bold)
                            
                        
                        Text("\(store.address), \(store.city), \(store.state)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        
                        // might need posted date
                    }
                    
                }
                
            }
            .foregroundStyle(.primary)
            .frame(maxHeight: 120)
            .padding()
        }
    }
}

#Preview {
    StoreListingView(store: DeveloperPreview.shared.stores[0])
}
