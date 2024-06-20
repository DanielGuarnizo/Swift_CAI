//
//  ListTemplateExercisesViewModel.swift
//  cai
//
//  Created by Daniel Guarnizo on 17/06/24.
//

import Foundation
/*class Webservice_create_template_exercise {
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
*/
/*class ListTemplateExercisesViewModel: ObservableObject{
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
}*/
