//
//  SwiftUIView.swift
//  Final Project
//
//  Created by Josh Lee on 3/29/23.
//

import SwiftUI

var dataTypeList = [
    Workout(title: "Push", routines:
                [Routine(id: 0, exercise: Exercise(id: 0, name: "Bench Press", description: "Push the mf bar up from chest", exercise_base: 0), sets: 4, reps: 10, weight: 155), Routine(id: 1, exercise: Exercise(id: 1, name: "Chest Flies", description: "Flap them wings like a butterfly", exercise_base: 0), sets: 4, reps: 10, weight: 135), Routine(id: 2, exercise: Exercise(id: 2, name: "Push Ups", description: "Don't stop 'til I say stop", exercise_base: 0), sets: 4, reps: 25, weight: 0)]),
    Workout(title: "Pull", routines:
                [Routine(id: 0, exercise: Exercise(id: 3, name: "Lat Pulldown", description: "Bring them lats down", exercise_base: 0), sets: 4, reps: 10, weight: 130), Routine(id: 1, exercise: Exercise(id: 4, name: "Bicep Curls", description: "Too small", exercise_base: 0), sets: 4, reps: 10, weight: 135), Routine(id: 2, exercise: Exercise(id: 5, name: "Pull Ups", description: "Can't even pull yourself together", exercise_base: 0), sets: 4, reps: 25, weight: 0)]),
    Workout(title: "Legs", routines:
                [Routine(id: 0, exercise: Exercise(id: 6, name: "Hip Thrusts", description: "Ughhhh", exercise_base: 0), sets: 4, reps: 8, weight: 225), Routine(id: 1, exercise: Exercise(id: 7, name: "Leg Press", description: "So many plates", exercise_base: 0), sets: 4, reps: 12, weight: 388), Routine(id: 2, exercise: Exercise(id: 8, name: "Bulgarian Split Squats", description: "Ouch", exercise_base: 0), sets: 4, reps: 25, weight: 40)])
]


struct WorkoutsView: View {
    @ObservedObject var vm: ViewModel
    @State private var editMode = EditMode.inactive
    
    private var addButton: some View {
        switch editMode {
        case .inactive:
            return AnyView(Button(action: addWorkout) { Image(systemName: "plus") })
        default:
            return AnyView(EmptyView())
        }
    }
    
    private func addWorkout() {
        vm.user.workouts.append(Workout(title: "", routines: []))
        vm.user.save()
    }
    
    func deleteWorkout(at: IndexSet) {
        vm.user.workouts.remove(atOffsets: at)
        vm.user.save()
    }
    
    func moveWorkout(from: IndexSet, to: Int) {
        vm.user.workouts.move(fromOffsets: from, toOffset: to)
        vm.user.save()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.user.workouts) { workout in
                    TestCell(vm: vm, name: workout.title, preview: workout.to_string(), workout: workout)
                }
                .onDelete { self.deleteWorkout(at :$0) }
                .onMove { self.moveWorkout(from: $0, to: $1) }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Workouts")
            .toolbar { EditButton() }
            .navigationBarItems(trailing: addButton)
            .background(Color(.systemGroupedBackground)).edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct Summary_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView(vm: ViewModel())
    }
}

struct TestCell: View {
    @ObservedObject var vm: ViewModel
    @State var name: String = ""
    @State var preview: String
    @ObservedObject var workout: Workout
    
    var body: some View {
        GroupBox(label: TextField("Untitled", text: $name)
            .onSubmit {
                self.workout.title = name
                print(workout.title)
                vm.user.save()
            }
            .font(.system(size: 24, weight: .bold, design: .default))) {
            HStack {
                Text(preview).font(.system(size: 14, weight: .regular, design: .rounded))
                    .foregroundColor(Color(.systemGray)).frame(width: 210, height: 15, alignment: .leading)
                Spacer()
            }
            .padding(.top, 2)
        }
        .groupBoxStyle(WorkoutGroupBox(color: .pink, destination: WorkoutListView(routine: ExerciseList(workout: workout))))
    }
}
