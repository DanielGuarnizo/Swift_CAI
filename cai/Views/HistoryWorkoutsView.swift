//
//  HistoryView.swift
//  cai
//
//  Created by Daniel Guarnizo on 30/05/24.
//

import SwiftUI

struct HistoryWorkoutsView: View {
    let user_id: Int
    @StateObject private var viewModel: HistoryWorkoutsViewModel
    
    init(user_id: Int){
        self.user_id = user_id
        _viewModel = StateObject(wrappedValue: HistoryWorkoutsViewModel(user_id: user_id))
    }

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    ForEach(viewModel.history_workouts) { workout in
                        HistoryWorkoutView(workout: workout)
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
            viewModel.load_history_workouts()
        }
    }
}


#Preview {
    HistoryWorkoutsView(user_id: 2)
}
