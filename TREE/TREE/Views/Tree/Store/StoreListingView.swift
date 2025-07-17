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
                    
                    VStack(alignment: .leading) {
                        Text("$\(store.price)")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .frame(height: 30)
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGreen).opacity(0.5))
                            .cornerRadius(10)
                        
                        Text("\(store.address), \(store.city), \(store.state)")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                        
                        // might need posted date
                    }
                    
                }
                
            }
            .foregroundStyle(.black)
            .frame(maxHeight: 120)
            .padding()
        }
    }
}

#Preview {
    StoreListingView(store: DeveloperPreview.shared.stores[0])
}
