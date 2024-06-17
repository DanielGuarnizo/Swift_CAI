//
//  Exercise.swift
//  cai
//
//  Created by Daniel Guarnizo on 03/06/24.
//

import Foundation
struct Exercise: Codable, Identifiable {
    let id = UUID()
    let exercise_id: Int
    let workout_id: Int
    let template_exercise_id: Int
    let exercise_name: String
    let muscle_group: String
    let category: String
    let sets: [Set_E]
    enum CodingKeys: String, CodingKey {
        case exercise_id = "exercise_id"
        case workout_id = "workout_id"
        case template_exercise_id = "template_exercise_id"
        case exercise_name = "exercise_name"
        case muscle_group = "muscle_group"
        case category = "category"
        case sets = "sets"
    }
}

/*
 [
    {'workout_id': 2,
    'template_exercise_id': 7,
    'muscle_group': 'Legs',
    'exercise_id': 1,
    'exercise_name': 'Squat',
    'category': 'Barbell',
    'sets': [
        Set(
            exercise_id=1,
            kg=100,
            type_rep=1,
            repetitions=10,
            set_id=1
        ),
        Set(exercise_id=1, kg=100, type_rep=1, repetitions=8, set_id=2)]}, {'workout_id': 5, 'template_exercise_id': 7, 'muscle_group': 'Legs', 'exercise_id': 8, 'exercise_name': 'Squat', 'category': 'Barbell', 'sets': [Set(exercise_id=8, kg=100, type_rep=1, repetitions=10, set_id=15), Set(exercise_id=8, kg=90, type_rep=1, repetitions=8, set_id=16)]}]
 */
