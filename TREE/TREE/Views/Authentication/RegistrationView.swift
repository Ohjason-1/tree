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
    @State var phoneNumberVerified = false
    private var isFormValid: Bool {
        return viewModel.userName.count > 0 && viewModel.password.count > 5 && viewModel.phoneNumber.count == 10 && phoneNumberVerified
    }
    
    private var numberInvalid: Bool {
        return (viewModel.phoneNumber.count != 10 && viewModel.phoneNumber.allSatisfy { $0.isNumber }) || viewModel.isLoading
    }
    
    private var codeInvalid: Bool {
        return (viewModel.verificationCode.count != 6 && viewModel.verificationCode.allSatisfy { $0.isNumber }) || viewModel.isLoading
    }
    
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
                    Text("Create Account")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .padding(.top, -8)
                        .padding(.bottom)
                }
                VStack(spacing: 20) {
                    DropDownRegister(placeHolder: "Username", text: $viewModel.userName, rightIcon: "person")
                        
                    
                    VStack(spacing: 8) {
                        DropDownRegister(placeHolder: "Password", text: $viewModel.password, rightIcon: "person.badge.key")
                            .textContentType(.password)
                            
                        
                        Text("Your password must be at least 6 characters in length")
                            .font(.caption)
                            .foregroundStyle(Color(.systemGray))
                    }
                    
                    
                    HStack(spacing: 12) {
                        DropDownRegister(placeHolder: "Mobile number", text: $viewModel.phoneNumber, rightIcon: "phone")
                            .textContentType(.telephoneNumber)
                            .keyboardType(.numberPad)
                        
                        Button {
                            sendCode()
                        } label: {
                            Text("Send code")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                                .frame(width: 80, height: 48)
                                .background(.green.gradient)
                                .cornerRadius(10)
                        }
                        .opacity(numberInvalid ? 0.5: 1)
                        .disabled(numberInvalid)
                        .alert(isPresented: $viewModel.showAlert) {
                            Alert(title: Text("Invalid Number"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
                        }
                    }
                    .padding(.bottom, -8)
                    
                    HStack(spacing: 64) {
                        DropDownRegister(placeHolder: "Code", text: $viewModel.verificationCode, rightIcon: "lock")
                            .keyboardType(.numberPad)
                            
                        
                        Button {
                            verifyCode()
                        } label: {
                            Text(phoneNumberVerified ? "Verified" : "Verify")
                                .font(.footnote)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                                .frame(width: 80, height: 48)
                                .background(.orange.gradient)
                                .cornerRadius(10)
                        }
                        .opacity(codeInvalid ? 0.5: 1)
                        .disabled(codeInvalid)
                        .alert(isPresented: $viewModel.showAlert) {
                            Alert(title: Text("Wrong Code"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
                        }
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("State")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                            
                            DropDownPost(menus: LocationData.allStates, selected: $viewModel.state, wantBlack: true)
                                .frame(height: 40)
                            
                        }
                        
                        Spacer()
                            .frame(width: 16)
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("City")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundStyle(.black)
                            
                            DropDownPost(menus: LocationData.cities(for: viewModel.state), selected: $viewModel.city, wantBlack: true)
                                .frame(height: 40)
                                .foregroundStyle(.black)
                        }
                        
                    }
                    .font(.caption)
                }
                .padding(16)
                .padding(.vertical)
                .background(
                    Rectangle()
                        .fill(.white)
                        .cornerRadius(16)
                        .shadow(radius: 16)
                )
                
                Spacer()
                
                NavigationLink {
                    EmailRegistrationView(viewModel: viewModel)
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("Next")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .frame(height: 50)
                        .frame(maxWidth: .infinity)
                        .background(.white.gradient)
                        .cornerRadius(16)
                        .shadow(radius: 16)
                }
                .padding(.vertical, 24)
                .opacity(!isFormValid ? 0.5: 1)
                .disabled(!isFormValid)
                
                
                Divider()
                
                Button {
                    viewModel.reset()
                    dismiss()
                } label: {
                    HStack(spacing: 3) {
                        Text("Already a user?")
                        
                        Text("Log In")
                            .fontWeight(.semibold)
                    }
                    .font(.footnote)
                    .foregroundStyle(.green.gradient)
                }
            }
            .padding(.horizontal)
            .background(Color("AccentColor").gradient)
        }
    }
    
    private func sendCode() {
        let number = "+1\(viewModel.phoneNumber)"
        Task {
            do {
                try await viewModel.sendVerificationCode(to: number)
            } catch {
            }
        }
    }
    
    private func verifyCode() {
        Task {
            do {
                let success = try await viewModel.verifyCode(viewModel.verificationCode)
                if success {
                    phoneNumberVerified = true
                }
            } catch {
            }
        }
    }
}

#Preview {
    RegistrationView()
}
