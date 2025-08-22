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
                
                Divider().scaleEffect(y: 1)
                
                HStack {
                    VStack(spacing: 12) {
                        HStack {
                            Text("State: ")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(.trailing)
                            
                            DropDownPost(menus: LocationData.allStates, selected: $viewModel.newState, wantBlack: false)
                                .frame(height: 36)
                            
                        }
                        HStack {
                            Text("City:   ")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .padding(.trailing)
                            
                            DropDownPost(menus: LocationData.cities(for: viewModel.state), selected: $viewModel.newCity, wantBlack: false)
                                .frame(height: 36)
                                .foregroundStyle(.black)
                        }
                    }
                    
                    
                    Button {
                        Task { try await viewModel.updateLocation() }
                    } label: {
                        Text("Update ")
                            .font(.footnote)
                            .fontWeight(.bold)
                            .foregroundStyle(Color(UIColor.label))
                            .frame(width: 72, height: 60)
                            .background(.green.gradient)
                            .cornerRadius(16)
                    }
                    .opacity((viewModel.newState.isEmpty || viewModel.newCity.isEmpty) ? 0.5 : 1)
                    .disabled(viewModel.newState.isEmpty || viewModel.newCity.isEmpty)
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(title: Text("Update Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
                    }
                    .padding(.leading, 24)
                }
                .padding(.horizontal)
                
                Divider().scaleEffect(y: 1)
                
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
//                        HStack {
//                            Image(systemName: "bell.circle.fill")
//                                .resizable()
//                                .frame(width: 24, height: 24)
//                                .foregroundStyle(Color(.systemPurple))
//                            Text("Notifications")
//                                .font(.subheadline)
//                        }
//                        HStack {
//                            Image(systemName: "bell.circle.fill")
//                                .resizable()
//                                .frame(width: 24, height: 24)
//                                .foregroundStyle(Color(.systemPurple))
//                            Text("Notifications")
//                                .font(.subheadline)
//                        }
                    }
                    .listRowBackground(Color(.systemOrange).opacity(0.2))
                    
                    
                    Section {
                        Button("Log Out") {
                            AuthService.shared.signOut() 
                        }
                        
                        Button("Delete Account") {
                            Task {
                                try await UserService.shared.deleteUser(user: user, viewModel: viewModel)
                                AuthService.shared.signOut()
                            }
                            
                        }
                    }
                    .foregroundStyle(.red)
                    .listRowBackground(Color(.systemGray6))
                    
                }
                .scrollContentBackground(.hidden)
            }
            .padding(.top)
        }
    }
}

#Preview {
    ProfileSettingView(user: DeveloperPreview.shared.user)
}
