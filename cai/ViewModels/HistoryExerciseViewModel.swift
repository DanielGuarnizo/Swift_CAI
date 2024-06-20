//
//  ExerciseHistoryViewModel.swift
//  cai
//
//  Created by Daniel Guarnizo on 03/06/24.
//

import Foundation

class Webservice_HistoryExerciseView {
    func get_history_exercise(template_exercise_id: Int, completion: @escaping(Result<[Exercise], APIError>)-> Void){
        // 1.Create the URL
        guard let url = URL(string: "http://localhost/api/v1/history/exercises/\(template_exercise_id)") else {
            completion(.failure(.networkError)) // we can do .failure(APIError.networkError) but swift implicitly knows that we mean APIError so we can put .networkError
            return
        }
        
        // get token of the current user
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "tokenName")
        //print("HISTORY EXERCISE token:")
        //print(token ?? "")
        
        // 2.Create URLRequet with the corresponding Headers
        var request = URLRequest(url:url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer " + (token ?? ""), forHTTPHeaderField: "Authorization")
        
        // 3. Create the request body if any(in this case given that is a GET we don't have to)
        
        // 4.Create the URLSessionConfiguration
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        // 5.Create a dataTask
        //print("THIS IS THE REQUEST TO THE API")
        //print(request.allHTTPHeaderFields ?? "IF YOU SEE THIS IT MEANS THERE ISN'T HEADERS IN SUCH REQUEST")
        let task = session.dataTask(with: request) { data, response, error in
            
            
            // we check if error is not empty
            if let error = error {
                completion(.failure(.custom(errorMessage: error.localizedDescription)))
                return
            }
            //print("AFTER CKECK ERROR")
            
            // invalidate Credential error
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidCredentials))
                return
            }
            //print("AFTER CKECK  HTTPRESPONSE")
            
            // Network error, not data received
            guard let data = data else {
                completion(.failure(.networkError))
                return
            }
            //print("AFTER CKECK DATA")
            
            // Perform Decoding
            do {
                //print("INSIDE THE DO ")
                // print( try JSONDecoder().decode([Exercise].self, from: data))
                let history_exercise = try JSONDecoder().decode([Exercise].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(history_exercise))
                }
            } catch {
                //print("INSIDE THE CATCH ")
                DispatchQueue.main.async {
                    completion(.failure(.custom(errorMessage: error.localizedDescription)))
                }
            }
        }
        
        task.resume()
    }
}

class HistoryExerciseViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var history_exercise: [Exercise] = []
    let template_exercise_id: Int
    
    init(template_exercise_id: Int) {
        self.template_exercise_id = template_exercise_id
    }
    
    
    func load_Exercise_history(){
        let webservice = Webservice_HistoryExerciseView()
        webservice.get_history_exercise(template_exercise_id: template_exercise_id) { result in
            //print("THIS IS THE RESULT OF THE LOAD_EXERCISE_HISTORY")
            //print(result)
            DispatchQueue.main.async {
                switch result {
                case .success(let history_exercise):
                    self.history_exercise = history_exercise
                    
                
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

