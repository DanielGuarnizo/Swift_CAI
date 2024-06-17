//
//  TemplateExercise.swift
//  cai
//
//  Created by Daniel Guarnizo on 31/05/24.
//

import Foundation
struct TemplateExercise: Codable, Identifiable {
    let id = UUID()
    let template_exercise_id: Int
    let template_workout_id: Int
    let order: Int?
    let name_exercise: String
    let muscle_group: String
    let category: String
    enum CodingKeys: String, CodingKey {
        case template_exercise_id = "template_exercise_id"
        case template_workout_id = "template_workout_id"
        case order = "order"
        case name_exercise = "name_exercise"
        case muscle_group = "muscle_group"
        case category = "category"
    }
}
