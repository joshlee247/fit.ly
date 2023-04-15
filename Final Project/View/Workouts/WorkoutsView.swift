//
//  SwiftUIView.swift
//  Final Project
//
//  Created by Josh Lee on 3/29/23.
//

import SwiftUI

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
        vm.workouts.append(Workout(title: "", routines: []))
        vm.user.save()
    }
    
    func deleteWorkout(at: IndexSet) {
        vm.workouts.remove(atOffsets: at)
        vm.user.save()
    }
    
    func moveWorkout(from: IndexSet, to: Int) {
        vm.workouts.move(fromOffsets: from, toOffset: to)
        vm.user.save()
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.workouts) { workout in
                    WorkoutCell(vm: vm, name: workout.title, preview: workout.to_string(), workout: workout)
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

struct WorkoutCell: View {
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
            .groupBoxStyle(WorkoutGroupBox(color: .pink, destination: WorkoutListView(exerciseList: ExerciseList(workout: workout, routines: workout.routines, user: User.sharedInstance), vm: vm, workout: workout)))
    }
}
