import SwiftUI

struct WorkoutCreate: Identifiable, Codable {
    let id = UUID()
    let template_workout_id: Int
    let workout_name: String
    let date: String
    let duration: TimeInterval
    let volume: Int
    let records: Int
    let exercises: [ExerciseCreate]
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

struct ExerciseCreate: Identifiable, Codable {
    let id = UUID()
    let template_exercise_id: Int
    let exercise_name: String
    let muscle_group: String
    let category: String
    var sets: [SetCreate]
    enum CodingKeys: String, CodingKey {
        case template_exercise_id = "template_exercise_id"
        case exercise_name = "exercise_name"
        case muscle_group = "muscle_group"
        case category = "category"
        case sets = "sets"
    }
}

struct SetCreate: Identifiable, Codable {
    let id = UUID()
    let kg: Int
    let repetitions: Int
    let type_rep: Int
    enum CodingKeys: String, CodingKey {
        case kg = "kg"
        case repetitions = "repetitions"
        case type_rep = "type_rep"
    }
}


