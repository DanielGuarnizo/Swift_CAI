//
//  ProfileView.swift
//  cai
//
//  Created by Daniel Guarnizo on 12/04/24.
//

import SwiftUI


struct ProfileView: View {
    @EnvironmentObject var viewModel: LoginViewViewModel
        
    var body: some View {
        VStack {
            Text("we are in the profileView")
            // Log In Button
            Button(action: {
                viewModel.signout()
            }) {
                Text("Signout")
                    .padding()
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
}

#Preview {
    ProfileView()
}
