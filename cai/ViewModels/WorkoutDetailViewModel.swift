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
            print("AFTER CKECK ERROR")
            
            // invalidate Credential error
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidCredentials))
                return
            }
            print("AFTER CKECK  HTTPRESPONSE")
            
            // Network error, not data received
            guard let data = data else {
                completion(.failure(.networkError))
                return
            }
            print("AFTER CKECK DATA")
            
            // Perform Decoding
            do {
                print("INSIDE THE DO ")
                // print( try JSONDecoder().decode([Exercise].self, from: data))
                print(data)
                let last_exercise = try JSONDecoder().decode(Exercise.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(last_exercise))
                }
            } catch {
                print("INSIDE THE CATCH ")
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
                    isCompleted: false,
                    order: 0
                )
            ]
        )
    ]

    let user_id: Int = UserDefaults.standard.integer(forKey: "user_id")
    let template_workout_id: Int = UserDefaults.standard.integer(forKey: "template_workout_id")
    
    
    /*func addSelectedExercises(selectedExercises: [TemplateExercise]) {
        var save: [Exercise] = last_exercises.map {$0}
        for template_exercise in selectedExercises {
            load_last_exercise(template_exercise_id: template_exercise.template_exercise_id)
        }
        self.last_exercises = save.map{$0}
        
    }*/
    func addSelectedExercises(selectedExercises: [TemplateExercise]) {
        print("ENTER IN THE addSelectedExercises FUNCTION ")
        print(selectedExercises)
        for template_exercise in selectedExercises {
            // Check if the exercise is already in the last_exercises
            if !last_exercises.contains(where: { $0.template_exercise_id == template_exercise.template_exercise_id }) {
                print("template_exercise_id \(template_exercise.template_exercise_id)")
                load_last_exercise(template_exercise_id: template_exercise.template_exercise_id)
            }
            print("OUT OF THE IF")
        }
    }
    

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
        print("ENTER IN THE load_last_exercise")
        let webservice = Webservice_loadLastExercise()
        webservice.get_last_exercise(template_exercise_id: template_exercise_id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let last_exercise):
                    print("THIS IS THE LAST EXERCISE")
                    print(last_exercise)
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
            var order_set = 1
            for set_in in exercise.sets {
                let exercise_set = WhileSet(kg: set_in.kg, repetitions: set_in.repetitions, type_rep: set_in.type_rep, isCompleted: false, order: order_set)
                exercise_create.sets.append(exercise_set)
                order_set = order_set + 1
            }
            exercises_create.append(exercise_create)
        }
        return exercises_create
    }
    
    // Convert from While Models to Create Models and then save such convertion

    func convertToExerciseCreate(exercise: WhileExercise) -> ExerciseCreate {
        /*let sets = exercise.sets.map { set in
            return SetCreate(kg: set.kg, repetitions: set.repetitions, type_rep: set.type_rep)
        }*/
        let sets = exercise.sets.filter {$0.isCompleted}.map { set in
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
        let date = Date().iso8601String // or fetch it from somewhere
        let duration: TimeInterval = 0.0
        let volume: Int = 0
        let records: Int = 0
        
        // Filter exercises where isCompleted is true, then map them to ExerciseCreate
        /*let exercisesCreate = exercises.filter { $0.isCompleted }.map { exercise in
            convertToExerciseCreate(exercise: exercise)
        }*/
        
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
            case .success(let workout_id):
                print("Succesfully create workout in the database: it's id \(workout_id)")
                // Handle success
            case .failure(let error):
                print("finish Workout")
                print(error)
                // Handle failure
            }
        }
    }
    
    
}
extension Date {
    var iso8601String: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter.string(from: self)
    }
}

class Webservice_post_history_workout {
    func post_history_workouts(workout_create: WorkoutCreate, completion: @escaping(Result<Int, APIError>)-> Void) {
        guard let url = URL(string: "http://localhost/api/v1/history/workouts") else {
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
            let jsonData = try encoder.encode(workout_create)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("THIS IS THE JSONSTRING")
                print(jsonString)
            }
            
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
                print("Do post_history_workouts")
                let workout_id = try JSONDecoder().decode(Int.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(workout_id))
                }
            } catch {
                print("Catch post_history_workouts")
                DispatchQueue.main.async {
                    completion(.failure(.custom(errorMessage: error.localizedDescription)))
                }
            }
        }
        
        task.resume()
    }
}
