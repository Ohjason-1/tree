//
//  LoginView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/15/25.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    private var isFormValid: Bool {
        return viewModel.email.contains("@") && viewModel.password.count > 5
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
                    TextField("Enter your email", text: $viewModel.email)
                        .modifier(TextFieldModifier())
                        
                    SecureField("Enter your password", text: $viewModel.password)
                        .modifier(TextFieldModifier())
                }
                
                // need to work on this
                Button {
                    print("Forgot password")
                } label: {
                    Text("What is my password?")
                        .underline()
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.top)
                        .padding(.trailing, 28)
                        .foregroundStyle(Color("Color"))
                }
                .frame(maxWidth: .infinity, alignment: .trailing)

                // check whether the email and pw exist
                Button {
                    Task {
                        do {
                            try await viewModel.login()
                        } catch {
                        }
                    }
                } label: {
                    Text("Login")
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
                .alert(isPresented: $viewModel.showingAlert) {
                    Alert(title: Text("Login Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
                }
                
                Spacer()
                
                Divider()
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack(spacing: 3) {
                        Text("Are you a new user?")
                        
                        Text("Sign Up")
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
    LoginView()
}
