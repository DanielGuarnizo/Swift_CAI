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
}

struct WhileExercise: Identifiable {
    let id = UUID()
    let template_exercise_id: Int
    let exercise_name: String
    let muscle_group: String
    let category: String
    var sets: [WhileSet]
}

struct WhileSet: Identifiable {
    let id = UUID()
    var kg: Int
    var repetitions: Int
    var type_rep: Int
    var isCompleted: Bool
}
