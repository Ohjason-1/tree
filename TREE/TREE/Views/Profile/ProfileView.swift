//
//  ProfileView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/15/25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
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
                ForEach(0...12, id: \.self) { index in
                    Post()
                }
            }
        }
    }
}


struct Post: View {
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image("Image")
                .resizable()
                .scaledToFill()
                .frame(width: 64, height: 64)
                .clipShape(.circle)
                
            
            VStack(alignment: .leading, spacing: 4) {
                Text("2520 Hillegass")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text("sublets")
                    .font(.subheadline)
                    .lineLimit(2)
                    .frame(maxWidth: UIScreen.main.bounds.width - 100, alignment: .leading)
            }
            
            HStack {
                Text("[07/12-10/23]")
                
                Image(systemName: "chevron.right")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
        .frame(height: 64)
    }
}

#Preview {
    ProfileView()
}
