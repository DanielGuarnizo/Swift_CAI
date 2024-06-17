//
//  Workout.swift
//  cai
//
//  Created by Daniel Guarnizo on 05/06/24.
//

import Foundation



struct Workout: Codable, Identifiable {
    let id = UUID()
    let workout_id: Int
    let user_id: Int
    let template_workout_id: Int
    let workout_name: String
    let date: String
    let duration: TimeInterval
    let volume: Int
    let records: Int
    let exercises: [Exercise]
    enum CodingKeys: String, CodingKey {
        case workout_id = "workout_id"
        case user_id = "user_id"
        case template_workout_id = "template_workout_id"
        case workout_name = "workout_name"
        case date = "date"
        case duration = "duration"
        case volume = "volume"
        case records = "records"
        case exercises = "exercises"
    }
}
