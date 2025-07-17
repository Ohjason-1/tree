//
//  LoginView.swift
//  TREE
//
//  Created by Jaewon Oh on 7/15/25.
//

import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @Binding var isLoggedIn: Bool
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
                    TextField("Enter your email", text: $email)
                        .modifier(TextFieldModifier())
                    
                    SecureField("Enter your password", text: $password)
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
                    isLoggedIn = true
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
                
                Spacer()
                
                Divider()
                
                NavigationLink {
                    RegistrationView(isLoggedIn: $isLoggedIn)
                        .navigationBarBackButtonHidden()
                } label: {
                    HStack(spacing: 3) {
                        Text("Are you a new user?")
                        
                        Text("Sign Up")
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
    LoginView(isLoggedIn: .constant(false))
}
