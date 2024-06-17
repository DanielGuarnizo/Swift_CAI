//
//  StartWorkout.swift
//  cai
//
//  Created by Daniel Guarnizo on 01/06/24.
//
import Foundation

enum APIError: Error {
    case networkError
    case invalidCredentials
    case custom(errorMessage: String)
}

import Foundation
class Webservice_HomeViewModel {
    func get_templates_workouts(completion: @escaping(Result<[TemplateWorkout], APIError>)-> Void){
        // 1.Create the URL
        guard let url = URL(string: "http://localhost/api/v1/templates_workouts") else {
            completion(.failure(.networkError)) // we can do .failure(APIError.networkError) but swift implicitly knows that we mean APIError so we can put .networkError
            return
        }
        
        // get token of the current user
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "tokenName")
        
        // 2.Create URLRequet with the corresponding Headers
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer " + (token ?? ""), forHTTPHeaderField: "Authorization")
        
        // 3. Create the request body if any(in this case we don't have to )
        
        // 4.Create the URLSessionConfiguration
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        // 5.Create a dataTask
        let task = session.dataTask(with: request) { data, response, error in
            
            // we check if error is not empty
            if let error = error {
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
                return
            }
            
            // invalidate Credential error
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidCredentials))
                return
            }
            
            // Network error, not data received
            guard let data = data else {
                completion(.failure(.networkError))
                return
            }
            
            // Perform Decoding
            do {
                let workouts = try JSONDecoder().decode([TemplateWorkout].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(workouts))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.custom(errorMessage: error.localizedDescription)))
                }
            }
            
        }
        
        task.resume()
    }
}

class : ObservableObject {
    @Published var workoutsDictionary: [String: [TemplateWorkout]] = [:]
    @Published var errorMessage: String = ""
     // If we declated and initialize the properties of the class at the same time, we don't need to implement the init in the class
    func loadWorkouts() {
        // Create an instance of the type Webservice_HomeViewModel, in such a way to be able to call its method
        let webservice = Webservice_HomeViewModel()
        
        // call the method off the type givenn the instance
        webservice.get_templates_workouts() { result in
            // print(result)
            DispatchQueue.main.async {
                switch result {
                case .success(let workouts):
                    let examplesWorkouts = workouts.filter { $0.user_id == 1 }
                    let customWorkouts = workouts.filter { $0.user_id != 1 }

                    self.workoutsDictionary["Examples"] = examplesWorkouts
                    self.workoutsDictionary["Custom"] = customWorkouts
                    
                
                case .failure(let error):
                    switch error {
                    case .networkError:
                        self.errorMessage = "Network error. Please try again."
                    case .invalidCredentials:
                        self.errorMessage = "Invalid credentials."
                    case .custom(let message):
                        self.errorMessage = message
                    }
                }
            }
        }
    }
    
}

