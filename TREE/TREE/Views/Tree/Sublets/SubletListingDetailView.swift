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
    @StateObject var viewModel = ProfileViewModel()
    var user: Users? { return viewModel.currentUser }
    
    var body: some View {
        ScrollView {
            TreeListingModifier(tree: sublet)
                .frame(height: 320)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("\(sublet.title)")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                
                Divider()
                    .background(.primary)
                // with required info like number of baths and bds, AI can write this down
                Text("\(sublet.description)")
                    .font(.subheadline)
                
                
                Divider()
                    .background(.primary)
                Group {
                    HStack(alignment: .center, spacing: 20) {
                        Image(systemName: "mappin.and.ellipse.circle")
                            .resizable()
                            .frame(width: 20, height: 20)
                        
                        VStack(alignment: .leading) {
                            Text("\(sublet.address), \(sublet.city), \(sublet.state)")
                            Text("\(sublet.zipcode)")
                        }
                        
                        Spacer()
                        
                        CircularProfileImageView(user: user, size: .small)
                    }
                    .font(.footnote)
                    
                    
                    HStack(spacing: 24) {
                        HStack {
                            Image(systemName: "bed.double")
                            
                            
                            Text("**\(sublet.numberOfBedrooms)** bedrooms")
                        }
                        
                        HStack {
                            Image(systemName: "bathtub")
                            
                            Text("**\(sublet.numberOfBathrooms)** bathrooms")
                                
                        }
                        
                        Spacer()
                        
                        Text(sublet.shared ? "Shared \(Image(systemName: "person.2.fill"))" : "Not shared \(Image(systemName: "person.fill"))")
                        
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
                            
                            HStack {
                                Text("**Start**: \(sublet.leaseStartDate.formatted(date: .abbreviated, time: .omitted))")
                                Spacer()
                                Text("**End**: \(sublet.leaseEndDate.formatted(date: .abbreviated, time: .omitted))")
                                    
                            }
                            .font(.footnote)
                            .padding(.trailing, 20)
                        }
                    }
                    .frame(height: 80)
                    .padding(.horizontal, 15)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.secondary.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    NavigationLink {
                        
                    } label: {
                        Text("Chat with Renter !")
                            .font(.subheadline)
                            .foregroundStyle(Color("AccentColor"))
                            .fontWeight(.semibold)
                            .frame(width: 360, height: 32)
                            .foregroundStyle(Color(UIColor.label))
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
