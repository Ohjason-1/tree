//
//  ProfileView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/15/25.
//

import SwiftUI
import PhotosUI

struct ProfileSettingView: View {
    @EnvironmentObject var viewModel: ProfileViewModel
    let user: Users
    
    var body: some View {
        NavigationStack {
            VStack {
                // header
                VStack {
                    
                    ZStack(alignment: .bottomTrailing) {
                        PhotosPicker(selection: $viewModel.selectedItem) {
                            if let image = MainActor.assumeIsolated({ viewModel.profileImage }) {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                            } else {
                                CircularProfileImageView(user: user, size: .medium)
                            }
                        }
                        
                        Image(systemName: "camera.circle.fill")
                            .resizable()
                            .background(.white)
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color(.systemGray))
                            .clipShape(.circle)
                            
                    }
                    
                    
                    Text(user.userName)
                        .font(.title2)
                        .fontWeight(.bold)
                }
                // list
                
                List {
                    Section {
                        NavigationLink {
                            CautionView()
                                .padding()
                        } label: {
                            HStack {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color(.systemPurple))
                                
                                Text("Caution")
                                    .font(.subheadline)
                            }
                        }
                        HStack {
                            Image(systemName: "bell.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color(.systemPurple))
                            Text("Notifications")
                                .font(.subheadline)
                        }
                        HStack {
                            Image(systemName: "bell.circle.fill")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color(.systemPurple))
                            Text("Notifications")
                                .font(.subheadline)
                        }
                    }
                    
                    
                    
                    Section {
                        Button("Log Out") {
                            AuthService.shared.signOut() 
                        }
                        
                        Button("Delete Account") {
                            Task { try await UserService.shared.deleteUser(user: user) }
                            AuthService.shared.signOut()
                        }
                    }
                    .foregroundStyle(.red)
                    
                }
                .background(Color("Color"))
                .scrollContentBackground(.hidden)
            }
            .padding(.top)
        }
    }
}

#Preview {
    ProfileSettingView(user: DeveloperPreview.shared.user)
}
