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
                
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("\(sublet.address), \(sublet.city), \(sublet.state)")
                        .font(.subheadline)
                        .lineLimit(1)
                    
                    
                    HStack {
                        Text("\(sublet.leaseStartDate.formatted(date: .numeric, time: .omitted)) - \(sublet.leaseEndDate.formatted(date: .numeric, time: .omitted))")
                            
                        
                        Spacer()
                        
                        Text("\(sublet.numberOfBedrooms) bed • \(sublet.numberOfBathrooms) bath")
                    }
                    .font(.caption)
                    .foregroundStyle(.primary.opacity(0.7))
                    
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
            
        }
        .foregroundStyle(.primary)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground))
                .shadow(color: .primary.opacity(0.1), radius: 6, x: 0, y: 4)
        }
        
    }
}

#Preview {
    SubletListingView(sublet: DeveloperPreview.shared.sublets[0])
}
