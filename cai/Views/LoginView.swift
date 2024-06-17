//
//  LoginView.swift
//  cai
//
//  Created by Daniel Guarnizo on 12/04/24.
//

import SwiftUI

struct LoginView: View {
    // @StateObject var viewModel = LoginViewViewModel()
    @EnvironmentObject var viewModel: LoginViewViewModel

    var body: some View {
        NavigationView {
            VStack {
                // Header
                HeaderView(Title: "CAI", SubTitle: "Callipatera AI ", angle: 10, backGround: .gray)
                
                
                
                // Login Form
                Form {
                    // Error message if not filled all fileds
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(Color.red)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    
                    // TextFields
                    TextField("Email Address", text: $viewModel.username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    // Log In Button
                    Button(action: {
                        viewModel.login()
                        viewModel.username = "" // Reset username
                        viewModel.password = "" // Reset password
                    }) {
                        Text("Login")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .padding(.top, 20)
                .alert(isPresented: $viewModel.loginAlert, content: {
                    Alert(title: Text("Error"), message: Text(viewModel.errorMessage))
                })
                
                // Create Acount
                VStack {
                    Text("New around here")
                    NavigationLink("Create An Account", destination: RegisterView())
                }
                .padding(.bottom, 50)
                
                Spacer()
                
            }
        }
    }
}

#Preview {
    LoginView()
}
