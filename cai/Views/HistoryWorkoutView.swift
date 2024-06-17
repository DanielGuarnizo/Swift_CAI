//
//  HistoryWorkoutView.swift
//  cai
//
//  Created by Daniel Guarnizo on 05/06/24.
//

import SwiftUI

struct HistoryWorkoutView: View {
    let workout: Workout
    
    
    func decode(date_in: String) -> Date? {
        // Instantiate DateFormatter
        let dateFormatter = DateFormatter()

        // Set the date format
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        // Convert the string to a Date object
        if let date = dateFormatter.date(from: date_in) {
            // Use the date object here
            return(date)
        } else {
            return Date()
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(workout.workout_name)
                    .font(.title2)
                    .bold()
                
                Spacer()
                
                /*Button(action: {
                    
                }) {
                    Image(systemName: "ellipsis")
                        .font(.title)
                        .foregroundColor(.gray)
                }*/
                Menu {
                    Button(action: {
                        // Edit Workout action
                    }) {
                        Label("Edit Workout", systemImage: "pencil")
                    }

                    Button(action: {
                        // Save as Template action
                    }) {
                        Label("Save as Template", systemImage: "plus")
                    }

                    Button(action: {
                        // Share action
                    }) {
                        Label("Share", systemImage: "square.and.arrow.up")
                    }

                    Button(action: {
                        // Delete action
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.title)
                        .foregroundColor(.gray)
                }


                
            }
            
            if let workoutDate = decode(date_in: workout.date) {
                Text(formattedDate(from: workoutDate))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            HStack(spacing: 20) {
                HStack {
                    Image(systemName: "clock")
                    Text(formattedDuration(from: workout.duration))
                }
                
                HStack {
                    Image(systemName: "scalemass")
                    Text("\(workout.volume) kg")
                }
                
                HStack {
                    Image(systemName: "trophy")
                    Text("\(workout.records) PRs")
                }
            }
            .font(.subheadline)
            .foregroundColor(.gray)
            
            Divider()
            
            HStack {
                Text("Exercise")
                    .font(.headline)
                Spacer()
                Text("Best Set")
                    .font(.headline)
            }
            
            ForEach(workout.exercises) { exercise in
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(exercise.sets.count) × \(exercise.exercise_name)")
                    }
                    Spacer()
                    if let bestSet = exercise.sets.max(by: { $0.kg < $1.kg }) {
                        Text("\(bestSet.kg) kg × \(bestSet.repetitions)")
                    } else {
                        Text("No sets")
                    }
                }
                .font(.body)
                .padding(.vertical, 2)
            }
        }
        .padding()
    }
    
    private func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func formattedDuration(from duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: duration) ?? ""
    }
}

#Preview {
    HistoryWorkoutView(workout: Workout(
        workout_id: 1,
        user_id: 1,
        template_workout_id: 1,
        workout_name: "Legs",
        date: "2023-05-27T00:00:00",
        duration: 5040, // 1h 24m converted to seconds
        volume: 15105,
        records: 0,
        exercises: [
            Exercise(exercise_id: 1, workout_id: 1, template_exercise_id: 1, exercise_name: "Squat (Barbell)", muscle_group: "Legs", category: "Strength", sets: [
                Set_E(set_id: 1, exercise_id: 1, kg: 90, repetitions: 10, type_rep: 0),
                Set_E(set_id: 2, exercise_id: 1, kg: 90, repetitions: 10, type_rep: 0)
            ]),
            Exercise(exercise_id: 2, workout_id: 1, template_exercise_id: 2, exercise_name: "Leg Extension (Machine)", muscle_group: "Legs", category: "Strength", sets: [
                Set_E(set_id: 3, exercise_id: 2, kg: 65, repetitions: 12, type_rep: 0)
            ]),
            Exercise(exercise_id: 3, workout_id: 1, template_exercise_id: 3, exercise_name: "Hip Thrust (Barbell)", muscle_group: "Glutes", category: "Strength", sets: [
                Set_E(set_id: 4, exercise_id: 3, kg: 80, repetitions: 12, type_rep: 0)
            ]),
            Exercise(exercise_id: 4, workout_id: 1, template_exercise_id: 4, exercise_name: "Lying Leg Curl (Machine)", muscle_group: "Hamstrings", category: "Strength", sets: [
                Set_E(set_id: 5, exercise_id: 4, kg: 35, repetitions: 12, type_rep: 0)
            ]),
            Exercise(exercise_id: 5, workout_id: 1, template_exercise_id: 5, exercise_name: "Standing Calf Raise (Machine)", muscle_group: "Calves", category: "Strength", sets: [
                Set_E(set_id: 6, exercise_id: 5, kg: 69, repetitions: 12, type_rep: 0)
            ])
        ]
    )
    )
}
