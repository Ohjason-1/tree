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
    @State private var selectedSublet: Sublets?
    @State private var selectedStore: Stores?
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                VStack {
                    HStack {
                        Text("Profile")
                            .font(.system(size: 36, weight: .black, design: .rounded))
                            .fontDesign(.rounded)
                            .foregroundStyle(Color("AccentColor").gradient)
                        Spacer()
                    }
                    .padding(.top, 24)
                    
                    CircularProfileImageView(user: user, size: .large)
                        
                    Text(user?.userName ?? "User 1")
                        .font(.title2)
                        .fontWeight(.bold)
                }
                .padding(.horizontal)
                
                if let user = user {
                    NavigationLink {
                        ProfileSettingView(user: user)
                            .toolbar(.hidden, for: .tabBar)
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
                    Button(action: {
                        // Handle navigation manually
                        if let sublet = tree as? Sublets {
                            selectedSublet = sublet
                        } else if let store = tree as? Stores {
                            selectedStore = store
                        }
                    }) {
                        ProfileElementView(tree: tree)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .navigationDestination(item: $selectedSublet) { sublet in
                SubletListingDetailView(sublet: sublet)
            }
            .navigationDestination(item: $selectedStore) { store in
                StoreListingDetailView(store: store)
            }
        }
    }
}



#Preview {
    ProfileView()
}
