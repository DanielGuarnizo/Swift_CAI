//
//  AddExerciseView.swift
//  cai
//
//  Created by Daniel Guarnizo on 19/06/24.
//

import SwiftUI



struct AddExerciseView: View {
    @State private var searchText = ""
    @State private var selectedMuscleGroup: String?
    @State private var selectedCategory: String?
    @State private var showMuscleGroupFilter = false
    @State private var showCategoryFilter = false
    @StateObject var viewModel: AddExerciseViewModel = AddExerciseViewModel()

    @Binding var selectedExercises: [TemplateExercise] // Binding to pass selected exercises

    var filteredExercises: [TemplateExercise] {
        viewModel.exercises.filter { exercise in
            (selectedMuscleGroup == nil || exercise.muscle_group == selectedMuscleGroup) &&
            (selectedCategory == nil || exercise.category == selectedCategory) &&
            (searchText.isEmpty || exercise.name_exercise.localizedCaseInsensitiveContains(searchText))
        }
    }

    var body: some View {
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
                ExerciseRow(exercise: exercise, isSelected: selectedExercises.contains(where: { $0.id == exercise.id })) {
                    toggleSelection(for: exercise)
                }
            }
        }
        .onAppear {
            viewModel.load_template_exercises_user()
        }
    }

    private func toggleSelection(for exercise: TemplateExercise) {
        if let index = selectedExercises.firstIndex(where: { $0.id == exercise.id }) {
            selectedExercises.remove(at: index)
        } else {
            selectedExercises.append(exercise)
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

struct ExerciseRow: View {
    let exercise: TemplateExercise
    var isSelected: Bool
    var onTap: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(exercise.name_exercise)
                    .font(.headline)
                Text(exercise.muscle_group)
                    .font(.subheadline)
            }
            Spacer()
            if isSelected {
                Image(systemName: "checkmark")
                    .foregroundColor(.blue)
            }
            if exercise.name_exercise == "Ab Wheel" {
                Text("8 reps")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onTap()
        }
    }
}


extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}

struct AddExerciseView_Previews: PreviewProvider {
    @State static var selectedExercises: [TemplateExercise] = []
    static var previews: some View {
        AddExerciseView(selectedExercises: $selectedExercises)
    }
}
