//
//  ExerciseView.swift
//  cai
//
//  Created by Daniel Guarnizo on 01/06/24.
//

import SwiftUI
import SlidingTabView

struct DetailTemplateExerciseView: View {
    let template_exercise_id: Int
    @State private var tabIndex = 0
    
    var body: some View {
        VStack {
            SlidingTabView(selection: $tabIndex, tabs: ["CAI","History", "About", "Records"], animation: .easeOut)
            // activateAccentColor, selectionBarColor
            
            //Spacer()
            
            switch tabIndex{
            case 0:
                ExerciseAnalysis()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case 1:
                HistoryExerciseView(template_exercise_id:template_exercise_id)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case 2:
                ExerciseAboutView(template_exercise_id:template_exercise_id)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            case 3:
                ExerciseRecordsView(template_exercise_id:template_exercise_id)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            default:
                Text("invalid tab index")
            }
            
        }
        .padding(.horizontal, 5)
        
    }
}


#Preview {
    DetailTemplateExerciseView(template_exercise_id: 7)
}
