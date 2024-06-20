//
//  AddExerciseViewModel.swift
//  cai
//
//  Created by Daniel Guarnizo on 19/06/24.
//

import Foundation
// 5 |                   2 |     2 | Standing Calf Raise | Legs         | Dumbell
class Webservice_TemplateExercisesUser{
    func get_templates_exericise_user(completion: @escaping(Result<[TemplateExercise], APIError>)-> Void){
        // 1.Create the URL
        guard let url = URL(string: "http://localhost/api/v1/template/exercises") else {
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
                let templates_exercise = try JSONDecoder().decode([TemplateExercise].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(templates_exercise))
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

class Webservice_create_template_exercise {
    func create_template_exercise(create_templateExercise: TemplateExercise, completion: @escaping(Result<TemplateExercise, APIError>)-> Void){
        guard let url = URL(string: "http://localhost/api/v1/templates/exercises") else {
            completion(.failure(.networkError))
            return
        }
        
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "tokenName")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer " + (token ?? ""), forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(create_templateExercise)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
            print("THE JSON FROM THE create Template Exericise")
            
            if let p = json {
                print(p)
            }
            // Put the body in the request
            request.httpBody = jsonData
        } catch {
            completion(.failure(.custom(errorMessage: error.localizedDescription)))
            return
        }

        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: request) { data, response, error in
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
                completion(.failure(.networkError))
                return
            }
            
            do {
                let template_exercise = try JSONDecoder().decode(TemplateExercise.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(template_exercise))
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

class AddExerciseViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var exercises: [TemplateExercise] = []
    /*[
        TemplateExercise(template_exercise_id: 5, template_workout_id: 2, order: nil, name_exercise: "Standing Calf Raise", muscle_group: "Legs", category: "Dumbell"),
        TemplateExercise(template_exercise_id: 2, template_workout_id: 1, order: nil, name_exercise: "Ab Wheel", muscle_group: "Core", category: "Core"),
        TemplateExercise(template_exercise_id: 3, template_workout_id: 1, order: nil, name_exercise: "Aerobics", muscle_group: "Cardio", category: "Cardio"),
        TemplateExercise(template_exercise_id: 4, template_workout_id: 1, order: nil, name_exercise: "Arnold Press (Dumbbell)", muscle_group: "Shoulders", category: "Strength")
    ]*/
    func load_template_exercises_user() {
        let webservice = Webservice_TemplateExercisesUser()
        webservice.get_templates_exericise_user() { result in
            //print("THIS IS THE RESULT OF THE LOAD_EXERCISE_HISTORY")
            //print(result)
            DispatchQueue.main.async {
                switch result {
                case .success(let templates_exercise):
                    self.exercises = templates_exercise
                    print("THIS ARE THE TAMPLATES EXERCISE OF THE GIVEN USER")
                    print(templates_exercise)
                
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
    
    func create_exercise(create_templateExercise: TemplateExercise){
        let webservice = Webservice_create_template_exercise()
        webservice.create_template_exercise(create_templateExercise: create_templateExercise){ result in
            switch result {
            case .success(let template_exercise):
                
                print("this is the template exercise id: \(template_exercise.template_exercise_id)")
            case .failure(let error):
                print("finish Workout")
                print(error)
            }
        }
    }
}
