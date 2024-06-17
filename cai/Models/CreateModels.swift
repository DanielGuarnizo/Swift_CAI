import SwiftUI

struct WorkoutCreate: Identifiable, Encodable {
    let id = UUID()
    let template_workout_id: Int
    let workout_name: String
    let date: Date
    let duration: TimeInterval
    let volume: Int
    let records: Int
    let exercises: [ExerciseCreate]
}

struct ExerciseCreate: Identifiable, Encodable {
    let id = UUID()
    let template_exercise_id: Int
    let exercise_name: String
    let muscle_group: String
    let category: String
    var sets: [SetCreate]
}

struct SetCreate: Identifiable, Encodable {
    let id = UUID()
    let kg: Int
    let repetitions: Int
    let type_rep: Int
}
