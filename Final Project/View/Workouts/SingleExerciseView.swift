//
//  SingleExerciseView.swift
//  Final Project
//
//  Created by Josh Lee on 4/13/23.
//

import SwiftUI

class RoutineObj: ObservableObject {
    @Published var routine: Routine
    @Published var sets: [WorkingSet]
    
    init(routine: Routine, sets: [WorkingSet]) {
        self.routine = routine
        self.sets = sets
    }
}

struct SingleExerciseView: View {
    @ObservedObject var vm: ViewModel
    @ObservedObject var routine: RoutineObj
    @State private var editMode = EditMode.inactive
    
    private func addWorkout() {
        // kinda hacky but it works
        // routine.routine = observable object
        routine.routine.sets.append(WorkingSet(id: UUID(), weight: 100, reps: 12, isCompleted: false))
        routine.sets.append(WorkingSet(id: UUID(), weight: 100, reps: 12, isCompleted: false))
        vm.user.save()
    }
    
    private var addButton: some View {
        switch editMode {
        case .inactive:
            return AnyView(Button(action: addWorkout) { Image(systemName: "plus") })
        default:
            return AnyView(EmptyView())
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack {
                    Image(systemName: "figure.strengthtraining.traditional").font(.title3)
                        .padding()
                }
                .frame(width: 45, height: 45)
                .foregroundColor(Color.white)
                .multilineTextAlignment(.center)
                .background(Color.pink)
                .clipShape(Circle())
                .padding(.trailing, 10)
                Text(routine.routine.exercise.name)
                    .font(.title)
                    .fontWeight(.semibold)
                    .frame(alignment: .leading)
            }
            .padding()
            
            List {
                ForEach(Array(zip(routine.sets.indices, routine.sets)), id: \.0) { i, workset in
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "dumbbell.fill").font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(.pink)
                            Text("Set \(i+1)").font(.system(size: 12, weight: .semibold, design: .rounded))
                                .foregroundColor(.pink)
                        }
                        HStack {
                            Text("\(workset.reps)").font(.system(size: 24, weight: .semibold, design: .rounded)) + Text(" reps").font(.system(size: 14, weight: .semibold, design: .rounded)).foregroundColor(.secondary)
                            Text("\(workset.weight, specifier: "%.0f")").font(.system(size: 24, weight: .semibold, design: .rounded)) + Text(" lbs").font(.system(size: 14, weight: .semibold, design: .rounded)).foregroundColor(.secondary)
                            Spacer()
                        }
                    }
                    .padding(.vertical, 10)
                    .swipeActions(edge: .leading) {
                        Button {
                            routine.sets[i].isCompleted.toggle()
                            print("toggled complete to: \(routine.sets[i].isCompleted)")
                        } label: {
                            routine.sets[i].isCompleted ? Label("X", systemImage: "x.circle") : Label("Completed", systemImage: "checkmark.circle.fill")
                        }
                        .tint(routine.sets[i].isCompleted ? .red : .green)
                    }
                    
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            print("Deleting set")
                            // this one works
                            routine.routine.sets.remove(at: i)
                            vm.user.save()
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                    }
                }
            }
            .navigationBarItems(trailing: addButton)
            .navigationBarTitle(
                Text(""), displayMode: .inline)
            .listStyle(.plain)
        }
    }
}

//struct SingleExerciseView_Previews: PreviewProvider {
//    static var previews: some View {
//        SingleExerciseView(vm: ViewModel(), routine: RoutineObj(routine: Routine(id: 0, exercise: Exercise(id: 0, name: "Bench Press", description: "Push bar up", exercise_base: 0), sets: [WorkingSet(id: UUID(), weight: 123, reps: 12, isCompleted: false), WorkingSet(id: UUID(), weight: 123, reps: 12, isCompleted: false), WorkingSet(id: UUID(), weight: 123, reps: 12, isCompleted: false)]), sets: [WorkingSet(id: UUID(), weight: 123, reps: 12, isCompleted: false), WorkingSet(id: UUID(), weight: 123, reps: 12, isCompleted: false), WorkingSet(id: UUID(), weight: 123, reps: 12, isCompleted: false)]))
//
//    }
//}
