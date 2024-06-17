//
//  ExerciseSetsView.swift
//  cai
//
//  Created by Daniel Guarnizo on 05/06/24.
//

import SwiftUI

struct ExerciseSetsView: View {
    let exercise: Exercise

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("here to put the name of the workout where it was performed")
                .font(.title3)
                .bold()

            Text(exercise.exercise_name)
                .font(.subheadline)
                .foregroundColor(.gray)

            Text(formattedDate(from: exercise))
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Sets Performed")
                .font(.headline)
                .padding(.top, 5)

            ForEach(exercise.sets) { set in
                HStack {
                    if set.type_rep == 1 { // Assuming type_rep 1 represents warm-up
                        Text("W")
                            .font(.body)
                            .foregroundColor(.orange)
                    } else {
                        Text("\(set.set_id)")
                            .font(.body)
                    }
                    Text("\(set.kg) kg × \(set.repetitions)")
                        .font(.body)
                    Spacer()
                    Text("\(calculate1RM(set: set))")
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 2)
            }
        }
        .padding()
    }

    // Function to calculate 1RM (one-rep max)
    func calculate1RM(set: Set_E) -> Int {
        // Placeholder formula for 1RM calculation, this can be replaced with the actual formula you use
        return Int(Double(set.kg) / (1.0278 - 0.0278 * Double(set.repetitions)))
    }

    // Function to format date
    func formattedDate(from exercise: Exercise) -> String {
        // Assuming exercise has a property for date, replace `Date()` with `exercise.date`
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: Date()) // Replace Date() with exercise.date
    }
}

/*#Preview {
    ExerciseSetsView(ex)
}*/
