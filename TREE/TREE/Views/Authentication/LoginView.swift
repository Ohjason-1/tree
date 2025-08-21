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
        return viewModel.isValidEmail() && viewModel.password.count > 5
    }
    
    @State private var resetPassword = false
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                VStack(spacing: 16) {
                    Image("AppIconWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 72, height: 72)
                    
                    Image("TREEWhite")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 72, height: 40)
                }
                    
                Spacer()
                
                Text("Sign in your account")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .padding(.vertical)
                    
                    
                
                VStack {
                    VStack(spacing: 20) {
                        DropDownRegister(placeHolder: "Email", text: $viewModel.email, rightIcon: "apple.meditate.circle")
                        
                          
                        DropDownRegister(placeHolder: "Password", text: $viewModel.password, rightIcon: "person.badge.key", isSecure: true)
                            .textContentType(.password)
                        }
                    
                    // need to work on this
                    Button {
                        resetPassword.toggle()
                    } label: {
                        Text("What is my password?")
                            .underline()
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .padding(.vertical)
                            .foregroundStyle(.orange)
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
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                            .background(Color("AccentColor").gradient)
                            .cornerRadius(10)
                    }
                    .padding(.vertical)
                    .opacity(!isFormValid ? 0.5: 1)
                    .disabled(!isFormValid)
                    .alert(isPresented: $viewModel.showingAlert) {
                        Alert(title: Text("Login Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
                    }
                    
                    Spacer()
                        .frame(maxHeight: 160)
                    
                    Divider().overlay(.black).scaleEffect(y: 1)
                    
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
                        .foregroundStyle(.green.gradient)
                    }
                    .padding(.top, 16)
                }
                .padding(.horizontal, 40)
                .padding(.top, 40)
                .background(
                    Rectangle()
                        .fill(.white)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .cornerRadius(16)
                        .shadow(radius: 16)
                        .ignoresSafeArea(.all, edges: .bottom)
                )
            }
            .background(Color("AccentColor").gradient)
            .sheet(isPresented: $resetPassword) {
                VStack(spacing: 24) {
                    Text("Reset your password")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                    
                    
                    DropDownRegister(placeHolder: "Email", text: $viewModel.email, rightIcon: "apple.meditate.circle")
                        .padding(.top, 16)
                    
                    Spacer()
                    
                    Button {
                        Task {
                            try await viewModel.sendPasswordReset()
                        }
                    } label: {
                        Text("Send")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundStyle(.white)
                            .frame(height: 44)
                            .frame(maxWidth: .infinity)
                            .background(Color("AccentColor").gradient)
                            .cornerRadius(10)
                    }
                    .opacity((!viewModel.isValidEmail() || viewModel.isLoading) ? 0.5: 1)
                    .disabled((!viewModel.isValidEmail() || viewModel.isLoading))
                    
                }
                .padding(40)
                .presentationDetents([.medium])
                .presentationBackground(.white.gradient)
            }
            .alert("Error", isPresented: $viewModel.showingAlert) {
                Button("OK") { }
            } message: {
                Text(viewModel.errorMessage)
            }
            if viewModel.isLoading {
                isUploadingView()
            }
        }
    }
}

#Preview {
    LoginView()
}
