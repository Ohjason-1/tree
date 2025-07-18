//
//  RegistrationView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/15/25.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel = RegistrationViewModel()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Image("Appicon")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .padding()
                
                VStack {
                    TextField("Enter your userName", text: $viewModel.userName)
                        .modifier(TextFieldModifier())
                    
                    TextField("Enter your phone number", text: $viewModel.phoneNumber)
                        .modifier(TextFieldModifier())
                
                    TextField("Enter your email", text: $viewModel.email)
                        .modifier(TextFieldModifier())
                    
                    SecureField("Enter your password", text: $viewModel.password)
                        .modifier(TextFieldModifier())
                    
                    Text("Your password must be at least 7 characters in length")
                        .font(.caption)
                        .foregroundStyle(Color(.systemGray))
                }
                
                Button {
                    Task { try await viewModel.createUser() }
                } label: {
                    Text("Sign Up")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .frame(width: 360, height: 44)
                        .background(Color("AccentColor"))
                        .cornerRadius(10)
                }
                .padding(.vertical)
                
                Spacer()
                
                Divider()
                
                Button {
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Text("Already a user?")
                        
                        Text("Sign In")
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                    .foregroundStyle(.black)
                }
                .padding(.vertical)
            }
        }
    }
}

#Preview {
    RegistrationView()
}
