//
//  ExerciseView.swift
//  cai
//
//  Created by Daniel Guarnizo on 01/06/24.
//

import SwiftUI
import SlidingTabView

struct TemplateExerciseView: View {
    let template_exercise: TemplateExercise
    @State private var tabIndex = 0
    
    var body: some View {
        VStack {
            SlidingTabView(selection: $tabIndex, tabs: ["History", "About", "Records"], animation: .easeOut)
            // activateAccentColor, selectionBarColor
            
            //Spacer()
            
            switch tabIndex{
            case 0:
                HistoryExerciseView(template_exercise_id: template_exercise.template_exercise_id)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case 1:
                ExerciseAboutView(exercise: template_exercise)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case 2:
                ExerciseRecordsView(exercise: template_exercise)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            default:
                Text("invalid tab index")
            }
            
        }
        .padding(.horizontal, 5)
        
    }
}


#Preview {
    TemplateExerciseView(template_exercise: TemplateExercise(
        template_exercise_id: 7,
        template_workout_id: 1,
        order: 1,
        name_exercise: "Push Up",
        muscle_group: "Chest",
        category: "Strength"
    ))
}
