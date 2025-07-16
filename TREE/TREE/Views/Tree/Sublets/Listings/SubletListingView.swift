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
            SubletListingModifier(sublet: sublet)
                .frame(height: 320)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            // listing details
            
            HStack(alignment: .top) {
                // details
                VStack(alignment: .leading) {
                    Text("$\(sublet.rentFee)")
                        
                    
                    Text("\(sublet.numberOfBedrooms) bedrooms, \(sublet.numberOfBathrooms) bathrooms")
                    
                    Text("\(sublet.address)")
                    
                    Text("\(sublet.shared)")
                }
                .fontWeight(.semibold)
                
                Spacer()
                // lease term
                
                VStack(alignment: .trailing) {
                    Text("\(sublet.leaseTermMonth)")
                    Text("\(sublet.leaseTermYear)")
                }
                .fontWeight(.semibold)
            }
            .font(.subheadline)
            .foregroundStyle(.black)
            .padding(.horizontal)
        }
    }
}

#Preview {
    SubletListingView(sublet: DeveloperPreview.shared.sublets[0])
}
