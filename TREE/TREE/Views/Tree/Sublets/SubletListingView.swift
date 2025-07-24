//
//  SubletListingView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/14/25.
//

import SwiftUI

struct SubletListingView: View {
    let sublet: Sublets
    
    var body: some View {
        VStack(spacing: 8) {
            // images
//            Divider()
//                .frame(maxWidth: UIScreen.main.bounds.width - 30)
//                .background(.primary)
                
            
            TreeListingModifier(tree: sublet)
                .frame(height: 320)
            
            // listing details
            
            HStack(spacing: 24) {
                VStack(alignment: .center, spacing: 6) {
                    Text("$\(sublet.rentFee)")
                        .font(.headline)
                    Image(systemName: sublet.shared ? "person.2.fill": "person.fill")
                        .font(.caption)
                }
                Divider()
                    .frame(height: 40)
                    .background(.primary)
                
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    Text("\(sublet.address), \(sublet.city), \(sublet.state)")
                        .font(.subheadline)
                        .lineLimit(1)
                    
                    
                    HStack {
                        Text("\(sublet.leaseStartDate.formatted(.dateTime.month().day().year())) - \(sublet.leaseEndDate.formatted(.dateTime.month().day().year()))")
                            .foregroundStyle(.primary)
                        
                        Spacer()
                        
                        Text("\(sublet.numberOfBedrooms) bed • \(sublet.numberOfBathrooms) bath")
                    }
                    .font(.caption)
                    .foregroundStyle(.primary.opacity(0.7))
                    
                }
            }
            .padding(.horizontal, 8)
            
        }
        .foregroundStyle(.primary)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    SubletListingView(sublet: DeveloperPreview.shared.sublets[0])
}
