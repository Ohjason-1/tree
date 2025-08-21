//
//  EmailRegistrationView.swift
//  TREE
//
//  Created by Jaewon Oh on 8/18/25.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift

struct EmailRegistrationView: View {
    @ObservedObject var viewModel: RegistrationViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
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
            
            Text("Verify your email address")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.vertical)
            
            VStack {
                VStack(alignment: .leading, spacing: 8) {
                    DropDownRegister(placeHolder: "Email", text: $viewModel.email, rightIcon: "apple.meditate.circle")
                        .textContentType(.emailAddress)
                    Text("Your password must be at least 6 characters in length")
                        .font(.caption)
                        .foregroundStyle(Color(.systemGray))
                }
                
                HStack {
                    VStack { Divider().overlay(.black).scaleEffect(y: 8) }
                    Text("or")
                        .padding(.horizontal, 4)
                    VStack { Divider().overlay(.black).scaleEffect(y: 8) }
                }
                .foregroundColor(.black)
                .padding(.vertical, 24)
                
                // SSO [google, etc]
                HStack {
                    GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .icon, state: .pressed)) {
                        Task {
                            do {
                                try await viewModel.signIngoogle()
                            } catch {
                                viewModel.showAlert = true
                            }
                        }
                    }
                    .alert(isPresented: $viewModel.showAlert) {
                        Alert(title: Text("Sign In Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
                    }
                }
            }
            .padding(24)
            .background(
                Rectangle()
                    .fill(.white)
                    .cornerRadius(20)
                    .shadow(radius: 16)
            )
    
            Spacer()
            // sign up button
            VStack(spacing: 16) {
                Button {
                    Task {
                        try await viewModel.sendRegistrationEmailLink()
                    }
                } label: {
                    Text("Sign up")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(.green.gradient)
                        .cornerRadius(16)
                }
                .disabled(!viewModel.isValidEmail() || viewModel.isLoading)
                .opacity((viewModel.isLoading || !viewModel.isValidEmail()) ? 0.5 : 1)
                if viewModel.isLoading { isUploadingView() }
                Button {
                    dismiss()
                } label: {
                    Text("Back")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(.red.gradient)
                        .cornerRadius(16)
                }
                .disabled(viewModel.isLoading)
                .opacity(viewModel.isLoading ? 0.5 : 1)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .onAppear { viewModel.resetVerification() }
        .background(Color("AccentColor").gradient)
        .alert("Error", isPresented: $viewModel.showAlert) {
            Button("OK") { }
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

#Preview {
    EmailRegistrationView(viewModel: RegistrationViewModel())
}
