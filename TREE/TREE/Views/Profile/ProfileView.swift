//
//  ProfileView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/15/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    var user: Users? { return viewModel.currentUser }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack {
                    HStack {
                        Image("Profile1")
                            .resizable()
                            .frame(width: 100, height: 24)
                            .padding(.vertical)
                        
                        Spacer()
                    }
                    
                    CircularProfileImageView(user: user, size: .large)
                        
                    Text(user?.userName ?? "User 1")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.horizontal)
                
                if let user = user {
                    NavigationLink {
                        ProfileSettingView(user: user)
                    } label: {
                        Text("Edit Profile")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color(UIColor.label))
                            .frame(width: 360, height: 32)
                            .overlay {
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color("AccentColor"), lineWidth: 2)
                            }
                    }
                } else {
                    Text("Edit Profile")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 360, height: 32)
                        .foregroundStyle(Color(UIColor.label))
                        .overlay {
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color("AccentColor"), lineWidth: 2)
                        }
                        .disabled(true)
                }
            }
            
            List {
                ForEach(viewModel.treeFeed, id: \.id) { tree in
                    ZStack {
                        NavigationLink(value: tree) {
                            EmptyView()
                        }
                        .opacity(0)
                        
                        ProfileElementView(tree: tree)
                    }
                }
            }
            .navigationDestination(for: Sublets.self) { sublet in
                SubletListingDetailView(sublet: sublet)
            }
            .navigationDestination(for: Stores.self) { store in
                StoreListingDetailView(store: store)
            }
        }
    }
}



#Preview {
    ProfileView()
}
