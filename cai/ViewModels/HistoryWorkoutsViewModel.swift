//
//  HistoryWorkoutsViewModel.swift
//  cai
//
//  Created by Daniel Guarnizo on 05/06/24.
//

import Foundation
class Webservice_HistoryWorkoutsViewModel{
    func get_history_workouts(user_id: Int,completion: @escaping(Result<[Workout], APIError>)-> Void){
        // 1.Create the URL
        guard let url = URL(string: "http://localhost/api/v1/history/workouts/\(user_id)") else {
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
                let history_workouts = try JSONDecoder().decode([Workout].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(history_workouts))
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


class HistoryWorkoutsViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var history_workouts: [Workout] = []
    let user_id: Int
    
    init(user_id:Int){
        self.user_id = user_id
    }
    
    func load_history_workouts(){
        let webservice = Webservice_HistoryWorkoutsViewModel()
        webservice.get_history_workouts(user_id: user_id) { result in
            print("THIS IS THE RESULT OF THE LOAD_HISTORY_WORKOUS")
            print(result)
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let workouts):
                    self.history_workouts = workouts
                    
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
