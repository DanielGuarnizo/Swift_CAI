//
//  TemplateWorkout.swift
//  cai
//
//  Created by Daniel Guarnizo on 31/05/24.
//

import Foundation

struct TemplateWorkout: Codable, Identifiable{
    let id = UUID() // Here we declared and initilize at the same time this property of the Swift Model
    let template_workout_id: Int
    let user_id: Int
    let workout_name: String
    let template_exercises : [TemplateExercise]
    enum CodingKeys: String, CodingKey {
        case template_workout_id = "template_workout_id"
        case user_id = "user_id"
        case workout_name = "workout_name"
        case template_exercises = "template_exercises"
    }
}

