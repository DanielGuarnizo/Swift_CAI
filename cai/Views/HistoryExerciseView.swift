//
//  ExerciseHistoryView.swift
//  cai
//
//  Created by Daniel Guarnizo on 03/06/24.
//

import SwiftUI

struct HistoryExerciseView: View {
    let template_exercise_id: Int
    @StateObject private var viewModel: HistoryExerciseViewModel

    // Initialize viewModel inside init
    init(template_exercise_id: Int) {
        self.template_exercise_id = template_exercise_id
        _viewModel = StateObject(wrappedValue: HistoryExerciseViewModel(template_exercise_id: template_exercise_id))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    ForEach(viewModel.history_exercise) { exercise in
                        ExerciseSetsView(exercise: exercise)
                            .frame(
                                maxWidth: .infinity,
                                
                                alignment: .center
                            )
                            .background(Color.white)
                            .cornerRadius(20)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.gray, lineWidth: 2)
                            )
                            .padding()
                    }
                }
                .frame(maxWidth: .infinity) // Ensure VStack takes the full width
            }
        }
        .onAppear {
            viewModel.load_Exercise_history()
        }
    }
}


#Preview {
    HistoryExerciseView(template_exercise_id: 7)
}
