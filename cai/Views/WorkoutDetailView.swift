///
//  Example.swift
//  cai
//
//  Created by Daniel Guarnizo on 05/06/24.
//

import SwiftUI

struct WorkoutDetailView: View {
    @StateObject var viewModel: WorkoutDetailViewModel = WorkoutDetailViewModel()
    @Binding var showWorkoutDetail: Bool
    @Binding var showWorkoutName: String
    @State var showPopupAddExercise: Bool = false
    @State private var selectedExercises: [TemplateExercise] = []
    
    var body: some View {
        GeometryReader { proxy in
            let height = proxy.frame(in: .global).height
            let offset: CGFloat = 0 // Assuming you have offset defined somewhere
            let opacity = min(max((offset / (height - 100)), 0), 1)
            
            NavigationView {
                VStack {
                    VStack {
                        Capsule()
                            .fill(Color.black)
                            .frame(width: 60, height: 4)
                    }
                    .frame(width: UIScreen.main.bounds.width/50, height: UIScreen.main.bounds.height/50)
                    
                    ScrollView(.vertical) {
                        VStack {
                            
                            // timer and finish button, also tittle of such template
                            VStack {
                                /*Capsule()
                                    .fill(Color.black)
                                    .frame(width: 60, height: 4)
                                    .padding(.top)*/
                                
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
                                        showWorkoutDetail.toggle()
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
                                //.padding(.horizontal,45)
                                .padding(.top, 20)
                                
                                HStack {
                                    Text(showWorkoutName)
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
                                //.padding(.horizontal,45)
                            }
                            .frame(width: UIScreen.main.bounds.width - 20)
                            
                            
                            VStack {
                                ForEach($viewModel.exercises) { $exercise in
                                    ExerciseView(exercise: $exercise, removeExercise: { removeExercise(exercise)
                                    })
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    withAnimation {
                                        showPopupAddExercise.toggle()
                                    }
                                }) {
                                    Text("Add Exercises")
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.blue.opacity(0.1))
                                        .cornerRadius(8)
                                        .foregroundColor(.blue)
                                }
                                
                                Button(action: {
                                    withAnimation{
                                        showWorkoutDetail.toggle()
                                    }
                                    
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
                            .frame(width: UIScreen.main.bounds.width - 10)
                        }
                        .navigationBarHidden(true) // Hide the default navigation bar
                        .onAppear {
                            viewModel.Fill_last_exercises()
                        }
                        
                    }
                }
                .popupNavigationView(show: $showPopupAddExercise) {
                    AddExerciseView(selectedExercises: $selectedExercises)
                        .navigationTitle("Add Exercise")
                        .navigationBarTitleDisplayMode(.inline)
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    // Return selected exercises
                                    print("THIS ARE THE SELECTED EXERCISES IN THE ADD EXERCISE VIEW ")
                                    print(selectedExercises)
                                    viewModel.addSelectedExercises(selectedExercises: selectedExercises)
                                    withAnimation {
                                        showPopupAddExercise.toggle()
                                    }
                                    self.selectedExercises = []
                                } label: {
                                    Text("Add")
                                }
                            }
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Close") {
                                    withAnimation {
                                        showPopupAddExercise.toggle()
                                    }
                                }
                            }
                        }
                }
                
            }
        }
    }
    private func removeExercise(_ exercise: WhileExercise) {
        viewModel.exercises.removeAll(where: { $0.id == exercise.id })
        viewModel.last_exercises.removeAll(where: { $0.template_exercise_id == exercise.template_exercise_id })
    }
}



struct ExerciseView: View {
    @Binding var exercise: WhileExercise
    var removeExercise: () -> Void

    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text(exercise.exercise_name)
                    .font(.headline)
                Spacer()
                Menu {
                    Button(action: {
                        // Action for option 1
                        withAnimation{
                            removeExercise()
                        }
                    }) {
                        Text("Remove Exercise")
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
            //.padding(.horizontal,30)
            .frame(width: UIScreen.main.bounds.width - 20)

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
                ExerciseSetView(set: $set, removeSet: {
                    removeSet(set)
                })
            }
            Button(action: {
                addSet(orderSet: exercise.sets.count)
            }) {
                Text("+ Add Set")
                    .padding(.vertical, 5)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
            //.padding(.horizontal,35)
            .frame(width: UIScreen.main.bounds.width - 25)
        }
        .padding(.vertical, 10)
        
    }
    
    private func addSet(orderSet: Int) {
        let newSet = WhileSet(
            kg: 0,
            repetitions: 0,
            type_rep: 0,
            isCompleted: false,
            order: orderSet + 1
        )
        exercise.sets.append(newSet)
    }

    private func removeSet(_ set: WhileSet) {
        if let index = exercise.sets.firstIndex(where: { $0.id == set.id }) {
            exercise.sets.remove(at: index)
            // Update order for remaining sets
            for i in 0..<exercise.sets.count {
                exercise.sets[i].order = i + 1
            }
        }
    }
}

struct ExerciseSetView: View {
    @Binding var set: WhileSet
    @State private var checkSet: String = "square.dashed"
    let removeSet: () -> Void

    // Variables to hold the initial values and a Bool to track if they are set
    @State private var initialKg: Int?
    @State private var initialRepetitions: Int?
    @State private var initialTypeRep: Int?

    var body: some View {
        HStack {
            Menu {
                Button(action: {
                    set.type_rep = set.type_rep == 1 ? 0 : 1
                }) {
                    Text("Warm-up")
                }
                Button(action: {
                    set.type_rep = set.type_rep == 2 ? 0 : 2
                }) {
                    Text("Drop Set")
                }
                Button(action: {
                    set.type_rep = set.type_rep == 3 ? 0 : 3
                }) {
                    Text("Failure")
                }
            } label: {
                Image(systemName: systemImageName(order: set.order, type: set.type_rep))
                    .font(.title2)
                    .foregroundColor(setTypeColor)
            }
            .frame(width: (UIScreen.main.bounds.width*3)/34)

            // Display initial values here
            Text("\(initialKg ?? 0) kg x \(initialRepetitions ?? 0) \(typeRepText(initialTypeRep ?? 0))")
                .frame(width: (UIScreen.main.bounds.width*10)/34)
                

            TextField("+kg", value: $set.kg, format: .number)
                .frame(width: (UIScreen.main.bounds.width*7)/34)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("Reps", value: $set.repetitions, format: .number)
                .frame(width: (UIScreen.main.bounds.width*7)/34)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            //Spacer()
            Menu {
                Button(action: {
                    self.checkSet = checkSet == "square.dashed.inset.filled" ? "square.dashed" : "square.dashed.inset.filled"
                    set.isCompleted.toggle()
                }) {
                    Text(set.isCompleted ? "Uncheck it" : "Completed")
                }
                Button(action: {
                    removeSet()
                }) {
                    Text("Remove Set")
                }
            } label: {
                Image(systemName: checkSet)
            }
            .frame(width:(UIScreen.main.bounds.width*3)/34)
        }
        .background(set.isCompleted ? Color.green.opacity(0.1) : Color.clear.opacity(0.1))
        .onAppear {
            // Initialize the initial values only once
            if initialKg == nil {
                initialKg = set.kg
                initialRepetitions = set.repetitions
                initialTypeRep = set.type_rep
            }
        }
    }

    private func systemImageName(order: Int, type: Int) -> String {
        switch type {
        case 1:
            return "w.circle"
        case 2:
            return "d.circle"
        case 3:
            return "f.circle"
        default:
            return "\(order).circle"
        }
    }

    private var setTypeColor: Color {
        switch set.type_rep {
        case 1:
            return .orange
        case 2:
            return .purple
        case 3:
            return .red
        default:
            return .gray
        }
    }

    private func typeRepText(_ typeRep: Int) -> String {
        switch typeRep {
        case 1:
            return "(W)"
        case 2:
            return "(D)"
        case 3:
            return "(F)"
        default:
            return ""
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @State static var showWorkoutDetail = false
    @State static var showWorkoutName = "Example Name"
    static var previews: some View {
        WorkoutDetailView(showWorkoutDetail: $showWorkoutDetail, showWorkoutName: $showWorkoutName)
    }
}
