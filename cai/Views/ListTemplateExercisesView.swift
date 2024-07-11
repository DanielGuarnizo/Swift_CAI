//
//  ExercisesView.swift
//  cai
//
//  Created by Daniel Guarnizo on 30/05/24.
//

import SwiftUI

struct ListTemplateExercisesView: View {
    @State private var searchText = ""
    @State private var selectedMuscleGroup: String?
    @State private var selectedCategory: String?
    @State private var showMuscleGroupFilter = false
    @State private var showCategoryFilter = false
    @State private var showPopup = false
    @State private var newExerciseName = ""
    @State private var newExerciseMuscleGroup: String?
    @State private var newExerciseCategory: String?
    @StateObject var viewModel: AddExerciseViewModel = AddExerciseViewModel()
    
    // Popup TemplateExerciseRow
    @State var showPopupDetailTemplateExercise: Bool = false
    @State var template_exercise = TemplateExercise(
        template_exercise_id: 7,
        template_workout_id: 1,
        order: 1,
        name_exercise: "Push Up",
        muscle_group: "Chest",
        category: "Strength"
    )

    var filteredExercises: [TemplateExercise] {
        viewModel.exercises.filter { exercise in
            (selectedMuscleGroup == nil || exercise.muscle_group == selectedMuscleGroup) &&
            (selectedCategory == nil || exercise.category == selectedCategory) &&
            (searchText.isEmpty || exercise.name_exercise.localizedCaseInsensitiveContains(searchText))
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    TextField("Search", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    HStack {
                        Button(action: {
                            showMuscleGroupFilter = true
                        }) {
                            Text(selectedMuscleGroup ?? "Any Body Part")
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                        .actionSheet(isPresented: $showMuscleGroupFilter) {
                            ActionSheet(
                                title: Text("Select Muscle Group"),
                                buttons: muscleGroupButtons()
                            )
                        }
                        .frame(width: UIScreen.main.bounds.width / 2)

                        Button(action: {
                            showCategoryFilter = true
                        }) {
                            Text(selectedCategory ?? "Any Category")
                                .padding(.horizontal)
                                .padding(.vertical, 8)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                        .actionSheet(isPresented: $showCategoryFilter) {
                            ActionSheet(
                                title: Text("Select Category"),
                                buttons: categoryButtons()
                            )
                        }
                    }
                }

                List(filteredExercises) { exercise in
                    Button(action:{
                        template_exercise = exercise
                        withAnimation{
                            showPopupDetailTemplateExercise.toggle()
                        }
                    }){
                        TemplateExerciseRow(exercise: exercise)
                    }
                    
                }
            }
            .onAppear {
                viewModel.load_template_exercises_user()
            }
            .navigationTitle("Exercises")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showPopup = true
                    }) {
                        Text("New")
                    }
                }
            }
            .sheet(isPresented: $showPopup) {
                NavigationView {
                    VStack {
                        HStack {
                            Button(action: {
                                showPopup = false
                            }) {
                                Image(systemName: "xmark")
                            }
                            Spacer()
                            Text("Create New Exercise")
                                .font(.headline)
                            Spacer()
                            Button(action: {
                                if !newExerciseName.isEmpty,
                                   let muscleGroup = newExerciseMuscleGroup,
                                   let category = newExerciseCategory {
                                    let newExercise = TemplateExercise(
                                        template_exercise_id: 0,
                                        template_workout_id: 0,
                                        order: nil,
                                        name_exercise: newExerciseName,
                                        muscle_group: muscleGroup,
                                        category: category
                                    )
                                    viewModel.create_exercise(create_templateExercise: newExercise)
                                }
                                showPopup = false
                            }) {
                                Text("Save")
                            }
                        }
                        .padding()
                        
                        TextField("Add Name", text: $newExerciseName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                        
                        Menu {
                            ForEach(viewModel.exercises.map { $0.muscle_group }.removingDuplicates(), id: \.self) { muscleGroup in
                                Button(muscleGroup) {
                                    newExerciseMuscleGroup = muscleGroup
                                }
                            }
                        } label: {
                            HStack {
                                Text("Body Part")
                                Spacer()
                                Text(newExerciseMuscleGroup ?? "None")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        
                        Menu {
                            ForEach(viewModel.exercises.map { $0.category }.removingDuplicates(), id: \.self) { category in
                                Button(category) {
                                    newExerciseCategory = category
                                }
                            }
                        } label: {
                            HStack {
                                Text("Category")
                                Spacer()
                                Text(newExerciseCategory ?? "None")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        
                        Spacer()
                    }
                    .navigationBarHidden(true)
                }
            }
            .popupNavigationView(show: $showPopupDetailTemplateExercise){
                DetailTemplateExerciseView(template_exercise_id: template_exercise.template_exercise_id)
                    .navigationTitle(template_exercise.name_exercise)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                
                            } label: {
                                Text("Edit")
                            }
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Close") {
                                withAnimation { showPopupDetailTemplateExercise.toggle() }
                            }
                        }
                    }
            }
        }
    }

    private func muscleGroupButtons() -> [ActionSheet.Button] {
        var buttons = viewModel.exercises.map { $0.muscle_group }.removingDuplicates().map { muscleGroup in
            ActionSheet.Button.default(Text(muscleGroup)) {
                selectedMuscleGroup = muscleGroup
            }
        }
        buttons.append(.cancel {
            selectedMuscleGroup = nil
        })
        return buttons
    }

    private func categoryButtons() -> [ActionSheet.Button] {
        var buttons = viewModel.exercises.map { $0.category }.removingDuplicates().map { category in
            ActionSheet.Button.default(Text(category)) {
                selectedCategory = category
            }
        }
        buttons.append(.cancel {
            selectedCategory = nil
        })
        return buttons
    }
}

struct TemplateExerciseRow: View {
    let exercise: TemplateExercise

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(exercise.name_exercise)
                    .font(.headline)
                Text(exercise.muscle_group)
                    .font(.subheadline)
            }
            Spacer()
            if exercise.name_exercise == "Ab Wheel" {
                Text("8 reps")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}


#Preview {
    ListTemplateExercisesView()
}
