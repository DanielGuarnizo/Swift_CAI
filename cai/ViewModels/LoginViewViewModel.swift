//
//  LoginViewViewModel.swift
//  cai
//
//  Created by Daniel Guarnizo on 12/04/24.
//

import Foundation

// models and structure for respnses
enum AuthenticationError: Error {
    case invalidCredentials
    case custom(errorMessage: String)
}

struct LoginResponse: Codable {
    let accessToken: String
    let tokenType: String
    let user_id: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case user_id = "user_id"
    }
}

class Webservice_LoginViewModel {
    func login(username: String, password: String, completion: @escaping(Result<String, AuthenticationError>) -> Void) {
        guard let url = URL(string: "http://localhost/api/v1/login/access-token") else {
            completion(.failure(.custom(errorMessage: "Invalid URL")))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let body = "grant_type=&username=\(username)&password=\(password)&scope=&client_id=&client_secret="
        request.httpBody = body.data(using: .utf8)
        
        // Step 4: Create a URLSessionConfiguration
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)

        let task = session.dataTask(with: request) { data, response, error in
            
            //print("Data: \(String(describing: data))")
            //print("Response: \(String(describing: response))")
            //print("Error: \(String(describing: error))")
                    
            
            if let error = error {
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidCredentials))
                return
            }

            guard let data = data else {
                completion(.failure(.custom(errorMessage: "No data received")))
                return
            }
            do {
                let loginResponse = try JSONDecoder().decode(LoginResponse.self, from: data)
                // save the user_id
                let defaults = UserDefaults.standard
                defaults.setValue(loginResponse.user_id, forKey: "user_id")
                
                // return the token in the response
                let token = loginResponse.accessToken
                completion(.success(token))
                print(token)
            } catch {
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
            }
        }

        task.resume()
    }
}
/*import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
}*/

class LoginViewViewModel: ObservableObject {
    @Published var loginAlert = false
    @Published var isAuthenticated: Bool = false
    @Published var errorMessage: String = ""
    @Published var user_id: String = ""
    
    var username: String = ""
    var password: String = ""

    func login() {
        guard validate() else { return }

        let defaults = UserDefaults.standard

        Webservice_LoginViewModel().login(username: username, password: password) { result in
            print(result)
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    defaults.setValue(token, forKey: "tokenName")
                    self.isAuthenticated = true
                case .failure(let error):
                    self.loginAlert = true
                    switch error {
                    case .invalidCredentials:
                        self.errorMessage = "Invalid credentials. Please try again."
                    case .custom(let errorMessage):
                        self.errorMessage = errorMessage
                    }
                }
            }
        }
    }

    func signout() {
        DispatchQueue.main.async {
            let defaults = UserDefaults.standard
            defaults.removeObject(forKey: "tokenName")
            self.isAuthenticated = false
        }
    }

    private func validate() -> Bool {
        // Clean the error message if used before
        errorMessage = ""

        // Check if fields are correctly filled
        guard !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill all fields"
            return false
        }

        // Check if email is well structured
        guard username.contains("@") && username.contains(".") else {
            errorMessage = "Please provide a correct email."
            return false
        }

        return true
    }
}


