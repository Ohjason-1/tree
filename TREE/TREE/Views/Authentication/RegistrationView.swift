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
    private var isFormValid: Bool {
        return viewModel.email.contains("@") && viewModel.password.count > 5 && viewModel.phoneNumber.count == 10 && viewModel.userName.count > 0
    }
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
                    
                    Text("Your password must be at least 6 characters in length")
                        .font(.caption)
                        .foregroundStyle(Color(.systemGray))
                    
                    HStack {
                        VStack(alignment: .leading) {
                            Text("State")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            DropDownPost(menus: LocationData.allStates, selected: $viewModel.state)
                                .frame(height: 48)
                        }
                        
                        Spacer()
                            .frame(width: 16)
                        
                        VStack(alignment: .leading) {
                            Text("City")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            DropDownPost(menus: LocationData.cities(for: viewModel.state), selected: $viewModel.city)
                                .frame(height: 48)
                        }
                        
                    }
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
                .opacity(!isFormValid ? 0.5: 1)
                .disabled(!isFormValid)
                
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
                    .foregroundStyle(Color(UIColor.label))
                }
                .padding(.vertical)
            }
        }
    }
}

#Preview {
    RegistrationView()
}
