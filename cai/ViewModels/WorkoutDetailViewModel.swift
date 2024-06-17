//
//  WorkoutDetailViewModel.swift
//  cai
//
//  Created by Daniel Guarnizo on 06/06/24.
//

import SwiftUI
import Combine
class Webservice_loadLastExercise {
    func get_last_exercise(template_exercise_id: Int, completion: @escaping(Result<Exercise, APIError>)-> Void){
        // 1.Create the URL
        guard let url = URL(string: "http://localhost/api/v1/history/last-exercise/\(template_exercise_id)") else {
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
                let last_exercise = try JSONDecoder().decode(Exercise.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(last_exercise))
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




import SwiftUI
import Combine

class WorkoutDetailViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var exist_last_workout: Bool = false
    @Published var last_exercises: [Exercise] = []

    @Published var exercises: [WhileExercise] = [
        WhileExercise(
            template_exercise_id: 1,
            exercise_name: "Squat",
            muscle_group: "Legs",
            category: "Barbell",
            sets: [
                WhileSet(
                    kg: 0,
                    repetitions: 0,
                    type_rep: 0,
                    isCompleted: false
                )
            ]
        )
    ]

    let user_id: Int = UserDefaults.standard.integer(forKey: "user_id")
    let template_workout_id: Int = UserDefaults.standard.integer(forKey: "template_workout_id")

    func Fill_last_exercises() {
        print("Enter in the Fill_last_exercises")
        let template_workout = loadTemplateWorkout()

        for template_exercise in template_workout.template_exercises {
            load_last_exercise(template_exercise_id: template_exercise.template_exercise_id)
        }
    }

    func loadTemplateWorkout() -> TemplateWorkout {
        if let data = UserDefaults.standard.data(forKey: "templateWorkout") {
            let decoder = JSONDecoder()
            do {
                let templateWorkout = try decoder.decode(TemplateWorkout.self, from: data)
                print("Template workout loaded successfully.")
                return templateWorkout
            } catch {
                print("Failed to load template workout: \(error)")
            }
        } else {
            print("No template workout found in UserDefaults.")
        }
        return TemplateWorkout(
            template_workout_id: 8,
            user_id: 2,
            workout_name: "Full Body",
            template_exercises: [
                TemplateExercise(
                    template_exercise_id: 7,
                    template_workout_id: 1,
                    order: 1,
                    name_exercise: "Push Up",
                    muscle_group: "Chest",
                    category: "Strength"
                )
            ]
        )
    }

    func load_last_exercise(template_exercise_id: Int) {
        let webservice = Webservice_loadLastExercise()
        webservice.get_last_exercise(template_exercise_id: template_exercise_id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let last_exercise):
                    self.last_exercises.append(last_exercise)
                    self.exercises = self.fetch_last_exercises()
                case .failure(let error):
                    switch error {
                    case .networkError:
                        self.errorMessage = "Network error. Please try again."
                    case .invalidCredentials:
                        print("load_last_exercises")
                        self.errorMessage = "Invalid credentials."
                    case .custom(let message):
                        self.errorMessage = message
                    }
                }
            }
        }
    }

    func fetch_last_exercises() -> [WhileExercise] {
        var exercises_create: [WhileExercise] = []
        for exercise in last_exercises {
            var exercise_create = WhileExercise(
                template_exercise_id: exercise.template_exercise_id,
                exercise_name: exercise.exercise_name,
                muscle_group: exercise.muscle_group,
                category: exercise.category,
                sets: []
            )

            for set_in in exercise.sets {
                let exercise_set = WhileSet(kg: set_in.kg, repetitions: set_in.repetitions, type_rep: set_in.type_rep, isCompleted: false)
                exercise_create.sets.append(exercise_set)
            }
            exercises_create.append(exercise_create)
        }
        return exercises_create
    }

    func convertToExerciseCreate(exercise: WhileExercise) -> ExerciseCreate {
        let sets = exercise.sets.map { set in
            return SetCreate(kg: set.kg, repetitions: set.repetitions, type_rep: set.type_rep)
        }

        return ExerciseCreate(
            template_exercise_id: exercise.template_exercise_id,
            exercise_name: exercise.exercise_name,
            muscle_group: exercise.muscle_group,
            category: exercise.category,
            sets: sets
        )
    }

    func convertToWorkoutCreate() -> WorkoutCreate {
        let workoutName = "Workout Name" // or fetch it from somewhere
        let date = Date() // or fetch it from somewhere
        let duration: TimeInterval = 0.0
        let volume: Int = 0
        let records: Int = 0
        let exercisesCreate = exercises.map { exercise in
            convertToExerciseCreate(exercise: exercise)
        }

        return WorkoutCreate(
            template_workout_id: template_workout_id,
            workout_name: workoutName,
            date: date,
            duration: duration,
            volume: volume,
            records: records,
            exercises: exercisesCreate
        )
    }

    func finishWorkout() {
        let workoutCreate = convertToWorkoutCreate()

        let webservice = Webservice_post_history_workout()
        webservice.post_history_workouts(workout_create: workoutCreate) { result in
            switch result {
            case .success(let workout):
                print(workout.workout_id)
                // Handle success
            case .failure(let error):
                print("finish Workout")
                print(error)
                // Handle failure
            }
        }
    }
}

class Webservice_post_history_workout {
    func post_history_workouts(workout_create: WorkoutCreate, completion: @escaping(Result<Workout, APIError>)-> Void) {
        guard let url = URL(string: "http://localhost/api/v1/history/workouts") else {
            completion(.failure(.networkError))
            return
        }
        
        let defaults = UserDefaults.standard
        let token = defaults.string(forKey: "tokenName")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("Bearer " + (token ?? ""), forHTTPHeaderField: "Authorization")
        
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(workout_create)
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
                let workout = try JSONDecoder().decode(Workout.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(workout))
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
