//
//  StartWorkoutView.swift
//  cai
//
//  Created by Daniel Guarnizo on 01/06/24.
//

import SwiftUI

struct StartWorkoutView: View {
    @StateObject private var viewModel = StartWorkoutViewModel()
    @State var showPopup: Bool = false
    @State var popupWorkout: TemplateWorkout? = nil
    
    @Binding var showWorkoutDetail: Bool
    @Binding var showWorkoutName: String
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                ScrollView(.vertical) {
                    VStack(spacing: 20) {
                        // Title over all the present templates
                        Text("Templates")
                            .bold()
                            .font(.title)
                            .frame(alignment: .center)
                        if let customWorkouts = viewModel.workoutsDictionary["Custom"] {
                            VStack(alignment: .leading) {
                                Text("Your Workouts")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding([.leading, .top])
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHGrid(rows: Array(repeating: GridItem(.fixed(150), spacing: 20), count: 1), spacing: 20) {
                                        ForEach(customWorkouts) { workout in
                                            Button(action: {
                                                popupWorkout = workout
                                                withAnimation{                       showPopup.toggle()
                                                }
                                            }) {
                                                TemplateWorkoutView(template_workout: workout)
                                                    .frame(width: 150, height: 150)
                                                    .background(Color.white)
                                                    .cornerRadius(15)
                                                    .shadow(radius: 3)
                                                    .padding([.leading, .bottom, .top])
                                            }
                                        }
                                    }
                                }
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .padding([.leading, .trailing])
                            }
                        }
                        
                        if let exampleWorkouts = viewModel.workoutsDictionary["Examples"] {
                            VStack(alignment: .leading) {
                                Text("Example Workouts")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .padding([.leading, .top])
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    LazyHGrid(rows: Array(repeating: GridItem(.fixed(150), spacing: 20), count: 1), spacing: 20) {
                                        ForEach(exampleWorkouts) { workout in
                                            Button(action: {
                                                popupWorkout = workout
                                                showPopup.toggle()
                                            }) {
                                                TemplateWorkoutView(template_workout: workout)
                                                    .frame(width: 150, height: 150)
                                                    .background(Color.white)
                                                    .cornerRadius(15)
                                                    .shadow(radius: 3)
                                                    .padding([.leading, .bottom, .top])
                                            }
                                        }
                                    }
                                }
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .padding([.leading, .trailing])
                            }
                        }
                    }
                    .onAppear {
                        viewModel.loadWorkouts()
                    }
                }
                .alert(isPresented: .constant(!viewModel.errorMessage.isEmpty)) {
                    Alert(
                        title: Text("Error"),
                        message: Text(viewModel.errorMessage),
                        dismissButton: .default(Text("OK"), action: {
                            @StateObject var MainviewModel = LoginViewViewModel()
                            MainviewModel.isAuthenticated = false
                        })
                    )
                }
                .popupNavigationView(horizontalPadding: 40, show: $showPopup) {
                    if let template_workout = popupWorkout {
                        VStack {
                            List {
                                ForEach(template_workout.template_exercises) { template_exercise in
                                    NavigationLink(template_exercise.name_exercise) {
                                        DetailTemplateExerciseView(template_exercise_id: template_exercise.template_exercise_id)
                                    }
                                }
                            }
                            .navigationTitle(template_workout.workout_name)
                            .navigationBarTitleDisplayMode(.inline)
                            .toolbar {
                                ToolbarItem(placement: .navigationBarTrailing) {
                                    Button {
                                        
                                    } label: {
                                        Image(systemName: "plus")
                                    }
                                }
                                ToolbarItem(placement: .navigationBarLeading) {
                                    Button("Close") {
                                        withAnimation { showPopup.toggle() }
                                    }
                                }
                            }
                            Button(action: {
                                let defaults = UserDefaults.standard
                                defaults.setValue(template_workout.template_workout_id, forKey: "template_workout_id")
                                
                                // Check if the template workout is saved successfully
                                let isSaved = saveTemplateWorkout(template_workout)
                                
                                if isSaved {
                                    showWorkoutName = template_workout.workout_name
                                    withAnimation {
                                        showPopup.toggle()
                                    }
                                    withAnimation {
                                        showWorkoutDetail.toggle()
                                    }
                                } else {
                                    // Handle the failure case, e.g., show an error message
                                    print("Failed to save template workout")
                                }
                            }) {
                                Text("Start Workout")
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            .padding(.bottom, 20)
                        }
                    } else {
                        Text("Exercise not found")
                    }
                }
            }
        }
    } // body View
    
    func saveTemplateWorkout(_ templateWorkout: TemplateWorkout) -> Bool {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(templateWorkout)
            UserDefaults.standard.set(data, forKey: "templateWorkout")
            print("Template workout saved successfully.")
        } catch {
            print("Failed to save template workout: \(error)")
            
        }
        return true
    }
}


struct Preview: View {
    @State private var showWorkoutDetail = true
    @State private var showWorkoutName = "Example Name"
    var body: some View {
        StartWorkoutView(showWorkoutDetail: $showWorkoutDetail, showWorkoutName: $showWorkoutName)
    }
}


#Preview {
    Preview()
}
