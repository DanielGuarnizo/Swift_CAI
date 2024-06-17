//
//  RegisterViewModel.swift
//  cai
//
//  Created by Daniel Guarnizo on 03/06/24.
//

import Foundation

class RegisterViewModel: ObservableObject{
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    init () {}
    // Main Code to register a new user
    func register() {
        
    }
    

    
    // Validation porcess to ensure standart user name and passwords
    private func validate() -> Bool{
        // Clean the error message if used before
        errorMessage = ""
        
        // Check if fields are correctly filled
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fills all fields"
            return false
        }
        
        // Check if email is well structure
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please provide a correct email."
            return false
        }
        
        // Check length of the pasword to enforce security
        guard password.count >= 8 else {
            errorMessage = "Please insert a password with at least 8 characters"
            return false
        }
        
        return true
    }
}
