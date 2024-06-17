//
//  WorkoutView.swift
//  cai
//
//  Created by Daniel Guarnizo on 01/06/24.
//

import SwiftUI

struct TemplateWorkoutView: View {
    let template_workout: TemplateWorkout
    @State var showPopup: Bool = false
    var body: some View {
        
        VStack(){
            Text(template_workout.workout_name + "\(template_workout.template_workout_id)")
                .font(.title)
                .foregroundColor(.black)
        }
    }
}
#Preview {
    TemplateWorkoutView(template_workout: TemplateWorkout(
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
        ]))
}
