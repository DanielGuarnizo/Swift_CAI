///
//  Example.swift
//  cai
//
//  Created by Daniel Guarnizo on 05/06/24.
//

import SwiftUI

struct WorkoutDetailView: View {
    @StateObject var viewModel: WorkoutDetailViewModel = WorkoutDetailViewModel()
    
    var body: some View {
        GeometryReader { proxy in
            let height = proxy.frame(in: .global).height
            let offset: CGFloat = 0 // Assuming you have offset defined somewhere
            let opacity = min(max((offset / (height - 100)), 0), 1)
            
            NavigationView {
                VStack {
                    Capsule()
                        .fill(Color.black)
                        .frame(width: 60, height: 4)
                        .padding(.top)
                    
                    HStack {
                        Button(action: {
                            // Add functionality for Timer
                        }) {
                            Text("Timer")
                                .bold()
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .opacity(1 - opacity)
                        
                        Spacer()
                        VStack {
                            Text("Legs")
                                .bold()
                            Text("10:19")
                        }
                        .opacity(opacity)
                        
                        Spacer()
                        Button(action: {
                            viewModel.finishWorkout()
                        }) {
                            Text("Finish")
                                .bold()
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.green)
                                .cornerRadius(8)
                        }
                        .opacity(1 - opacity)
                    }
                    .padding([.horizontal, .top])
                    
                    HStack {
                        Text("New Template")
                            .font(.title)
                            .bold()
                        Spacer()
                        Menu {
                            Button(action: {
                                // Action for option 1
                            }) {
                                Text("Option 1")
                            }
                            Button(action: {
                                // Action for option 2
                            }) {
                                Text("Option 2")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .font(.title)
                        }
                    }
                    .padding(.horizontal)
                    
                    VStack {
                        ForEach($viewModel.exercises) { $exercise in
                            ExerciseView(exercise: $exercise)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            addExercise()
                        }) {
                            Text("Add Exercises")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue.opacity(0.1))
                                .cornerRadius(8)
                                .foregroundColor(.blue)
                        }
                        
                        Button(action: {
                            // Add functionality to cancel workout
                        }) {
                            Text("Cancel Workout")
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(8)
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                }
                .navigationBarHidden(true) // Hide the default navigation bar
                .onAppear {
                    viewModel.Fill_last_exercises()
                }
            }
        }
    }
    
    private func addExercise() {
        let newExercise = WhileExercise(template_exercise_id: 1, exercise_name: "Squat", muscle_group: "Legs", category: "Barbell", sets: [
            WhileSet(
                kg: 0,
                repetitions: 0,
                type_rep: 0,
                isCompleted: false
            )
        ])
        viewModel.exercises.append(newExercise)
    }
}



struct ExerciseView: View {
    @Binding var exercise: WhileExercise
    
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text(exercise.exercise_name)
                    .font(.headline)
                Spacer()
                Menu {
                    Button(action: {
                        // Action for option 1
                    }) {
                        Text("Option 1")
                    }
                    Button(action: {
                        // Action for option 2
                    }) {
                        Text("Option 2")
                    }
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
            
            HStack {
                Text("Set")
                    .frame(width: UIScreen.main.bounds.width / 5)
                Text("Previous")
                    .frame(width: UIScreen.main.bounds.width / 5)
                Text("+Kg")
                    .frame(width: UIScreen.main.bounds.width / 5)
                Text("Reps")
                    .frame(width: UIScreen.main.bounds.width / 5)
                Image(systemName: "checkmark")
                    .frame(width: UIScreen.main.bounds.width / 5)
                    .foregroundColor(.black)
                    .background(.white)
                    .cornerRadius(5)
                
            }
            ForEach($exercise.sets) { $set in
                ExerciseSetView(set: $set)
            }
            Button(action: {
                addSet()
            }) {
                Text("+ Add Set")
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
        }
        .padding(.vertical, 10)
        
    }
    
    private func addSet() {
        let newSet = WhileSet(
            kg: 0,
            repetitions: 0,
            type_rep: 0,
            isCompleted: false
        )
        exercise.sets.append(newSet)
    }
}

struct ExerciseSetView: View {
    @Binding var set: WhileSet
    
    var body: some View {
        HStack {
            Text("\(set.type_rep)")
                .frame(width: UIScreen.main.bounds.width / 5)
                .background(set.isCompleted ? Color.green : Color.clear)
                .cornerRadius(5)
            Text("-")
                .frame(width: UIScreen.main.bounds.width / 5)
            TextField("+kg", value: $set.kg, format: .number)
                .frame(width: UIScreen.main.bounds.width / 5)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Reps", value: $set.repetitions, format: .number)
                .frame(width: UIScreen.main.bounds.width / 5)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Spacer()
            Button(action: {
                set.isCompleted.toggle()
            }) {
                Image(systemName: "checkmark")
                    .frame(width: UIScreen.main.bounds.width / 5)
                    .foregroundColor(set.isCompleted ? .white : .black)
                    .padding(5)
                    .background(set.isCompleted ? Color.green : Color.clear)
                    .cornerRadius(5)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutDetailView()
    }
}
