//
//  RegisterView.swift
//  cai
//
//  Created by Daniel Guarnizo on 12/04/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewModel()
    
    var body: some View {
        VStack {
            
            // Header
            HeaderView(Title: "Register", SubTitle: "Start Organazing todos", angle: -15, backGround: .purple)
                .offset(y:-15)
            
            // Register Form
            Form {
                // TextFields
                TextField("Full Name", text: $viewModel.name)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocorrectionDisabled()
                
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(DefaultTextFieldStyle())
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(DefaultTextFieldStyle())
                
                // Register Button
                TLButton(
                    label: "Create Account",
                    backGround: .green
                ){
                    // Register Button
                    viewModel.register()
                }
            }
            .padding(.top, 20)
            
            // Spacer
            Spacer()
            
            
        }
    }
}

#Preview {
    RegisterView()
}
