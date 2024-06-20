//
//  WhileModels.swift
//  cai
//
//  Created by Daniel Guarnizo on 17/06/24.
//

import Foundation
struct WhileWorkout: Identifiable {
    let id = UUID()
    let template_workout_id: Int
    let workout_name: String
    let date: Date
    let duration: TimeInterval
    let volume: Int
    let records: Int
    let exercises: [WhileExercise]
    enum CodingKeys: String, CodingKey {
        case template_workout_id = "template_workout_id"
        case workout_name = "workout_name"
        case date = "date"
        case duration = "duration"
        case volume = "volume"
        case records = "records"
        case exercises = "exercises"
    }
    
}

struct WhileExercise: Identifiable {
    let id = UUID()
    let template_exercise_id: Int
    let exercise_name: String
    let muscle_group: String
    let category: String
    var sets: [WhileSet]
    enum CodingKeys: String, CodingKey {
        case template_exercise_id = "template_exercise_id"
        case exercise_name = "exercise_name"
        case muscle_group = "muscle_group"
        case category = "category"
        case sets = "sets"
    }
}

struct WhileSet: Identifiable {
    let id = UUID()
    var kg: Int
    var repetitions: Int
    var type_rep: Int
    var isCompleted: Bool
    var order: Int
    enum CodingKeys: String, CodingKey {
        case kg = "kg"
        case repetitions = "repetitions"
        case type_rep = "type_rep"
        case isCompleted = "isCompleted"
    }
}
