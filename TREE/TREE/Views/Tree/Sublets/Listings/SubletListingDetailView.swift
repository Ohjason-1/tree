//
//  SubletListingDetailView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/14/25.
//

import SwiftUI

struct SubletListingDetailView: View {
    //@Environment(\.dismiss) var dismiss
    let sublet: Sublets
    
    var body: some View {
        ScrollView {
            SubletListingModifier(sublet: sublet)
                .frame(height: 320)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("\(sublet.title)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Divider()
                    .background(.black)
                // with required info like number of baths and bds, AI can write this down
                Text("\(sublet.explanation)")
                    .font(.subheadline)
                
                
                Divider()
                    .background(.black)
                Group {
                    HStack(alignment: .center, spacing: 20) {
                        Image(systemName: "mappin.and.ellipse.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        VStack(alignment: .leading) {
                            Text("\(sublet.address), \(sublet.city), \(sublet.state)")
                            Text("\(sublet.zipcode)")
                        }
                    }
                    .font(.footnote)
                    
                    
                    HStack(spacing: 24) {
                        HStack {
                            Image(systemName: "bed.double")
                            
                            
                            Text("**\(sublet.numberOfBedrooms)** bedrooms")
                        }
                        
                        HStack {
                            Image(systemName: "bathtub")
                            
                            Text("**\(sublet.numberOfBedrooms)** bathrooms")
                                
                        }
                    }
                    .font(.footnote)
                    
                    Text("$ **\(sublet.rentFee)** /month")
                        .foregroundStyle(Color("AccentColor"))
                        .frame(height: 50)
                        .padding(.leading, 15)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color("Color").opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "calendar")
                            .padding(.top, 2)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Lease Term")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Text("\(sublet.leaseTermMonth), \(sublet.leaseTermYear)")
                                .font(.footnote)
                        }
                    }
                    .frame(height: 80)
                    .padding(.leading, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    NavigationLink {
                        
                    } label: {
                        Text("Cheap Furnitures !")
                            .font(.subheadline)
                            .foregroundStyle(Color("AccentColor"))
                            .fontWeight(.semibold)
                            .frame(width: 360, height: 32)
                            .foregroundStyle(.black)
                            .overlay {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color("AccentColor"), lineWidth: 1)
                            }
                    }

                        
                }
                .padding(.horizontal, 8)
            }
            .padding()
        }
    }
}

#Preview {
    SubletListingDetailView(sublet: DeveloperPreview.shared.sublets[0])
}
