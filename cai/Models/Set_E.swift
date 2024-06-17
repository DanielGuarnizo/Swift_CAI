//
//  Set.swift
//  cai
//
//  Created by Daniel Guarnizo on 03/06/24.
//

import Foundation
struct Set_E: Codable, Identifiable {
    let id = UUID()
    let set_id: Int
    let exercise_id: Int
    let kg: Int
    let repetitions: Int
    let type_rep: Int
    enum CodingKeys: String, CodingKey {
        case set_id = "set_id"
        case exercise_id = "exercise_id"
        case kg = "kg"
        case repetitions = "repetitions"
        case type_rep = "type_rep"
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
/*
class Set(SQLModel, table=True):
    set_id: int | None = Field(default=None, primary_key=True)
    exercise_id: int | None = Field(
        default=None, foreign_key="exercise.exercise_id", nullable=False
    )
    kg: int
    repetitions: int
    type_rep: int
    exercise: Exercise | None = Relationship(back_populates="sets")
*/
