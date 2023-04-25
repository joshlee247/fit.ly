//
//  SingleExerciseView.swift
//  Final Project
//
//  Created by Josh Lee on 4/13/23.
//

import SwiftUI
import ActivityKit

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
    @State private var isShowingAddSheet = false
    @State private var isShowingEditSheet = false
    @State private var set_to_edit = -1
    @State private var workoutNotStarted = false
    
    @State var activity: Activity<TimerAttributes>?
    @State var startTime: Date?
    
    private func addWorkout() {
        isShowingAddSheet.toggle()
    }
    
    func updateSetsLiveActivity(completed: Int, total: Int) {
        if let a = activity {
            var state = TimerAttributes.TimerStatus(startTime: startTime!, currentExercise: "--", sets_completed: completed, total_sets: total)
            
            if let exercise = vm.currentExercise {
                state = TimerAttributes.TimerStatus(startTime: startTime!, currentExercise: exercise, sets_completed: completed, total_sets: total)
            }
            
            Task {
                await a.update(using: state)
            }
        }
    }
    
    private var addButton: some View {
        switch editMode {
        case .inactive:
            return AnyView(Button(action: addWorkout) { Image(systemName: "plus") })
        default:
            return AnyView(EmptyView())
        }
    }
    
    func didDismiss() {
        // do something
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
                            if (workset.isCompleted) {
                                Image(systemName: "checkmark.circle.fill").font(.system(size: 24, weight: .semibold, design: .rounded))
                                    .foregroundColor(.pink)
                            }
                        }
                    }
                    .padding(.vertical, 10)
                    .swipeActions(edge: .leading) {
                        Button {
                            if vm.user.isWorkingOut {
                                workoutNotStarted = false
                                routine.objectWillChange.send()
                                routine.sets[i].isCompleted.toggle()
                                if (routine.sets[i].isCompleted) {
                                    vm.user.completedSets.append(CompletedSet(date: Date.now, exercise: routine.routine.exercise, weight: routine.sets[i].weight, reps: routine.sets[i].reps))
                                    vm.user.save()
                                } else {
                                    vm.user.completedSets.removeLast()
                                    vm.user.save()
                                }
                                print("toggled complete to: \(routine.sets[i].isCompleted)")
                                updateSetsLiveActivity(completed: routine.routine.getSetsCompleted(), total: routine.routine.sets.count)
                            } else {
                                workoutNotStarted = true
                            }
                        } label: {
                            routine.sets[i].isCompleted ? Label("X", systemImage: "xmark.circle.fill") : Label("Completed", systemImage: "checkmark.circle.fill")
                        }
                        .tint(routine.sets[i].isCompleted ? .red : .green)
                    }
                    
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            print("Deleting set")
                            // this one works
                            routine.routine.sets.remove(at: i)
                            routine.sets.remove(at: i)
                            vm.user.save()
                            updateSetsLiveActivity(completed: routine.routine.getSetsCompleted(), total: routine.routine.sets.count)
                        } label: {
                            Label("Delete", systemImage: "trash.fill")
                        }
                        
                        Button {
                            print("Editing set")
                            set_to_edit = Int(i)
                            print("index: \(set_to_edit)")
                            isShowingEditSheet = true
                            
                        } label: {
                            Label("Edit", systemImage: "square.and.pencil")
                        }
                        .tint(.blue)
                    }
                }
            }
            .alert(isPresented: $workoutNotStarted) {
                Alert(title: Text("Alert"), message: Text("Make sure you start your workout to save your progress!"), dismissButton: .cancel(Text("Got it!")))
            }
            .navigationBarItems(trailing: addButton)
            .navigationBarTitle(
                Text(""), displayMode: .inline)
            .listStyle(.plain)
            .sheet(isPresented: $isShowingAddSheet,
                   onDismiss: didDismiss) {
                if let a = activity {
                    AddSingleExerciseView(routineObj: routine, vm: vm, activity: a, startTime: startTime)
                } else {
                    AddSingleExerciseView(routineObj: routine, vm: vm)
                }
            }
           .sheet(isPresented: $isShowingEditSheet,
                  onDismiss: didDismiss) {
               if let a = activity {
                   EditSingleExerciseView(routineObj: routine, vm: vm, index: $set_to_edit, activity: a, startTime: startTime)
               } else {
                   EditSingleExerciseView(routineObj: routine, vm: vm, index: $set_to_edit)
               }
           }
        }
        .onAppear {
            vm.currentExercise = routine.routine.exercise.name
            updateSetsLiveActivity(completed: routine.routine.getSetsCompleted(), total: routine.routine.sets.count)
        }
    }
}

struct AddSingleExerciseView: View {
    @ObservedObject var routineObj: RoutineObj
    @ObservedObject var vm: ViewModel
    
    @State var activity: Activity<TimerAttributes>?
    @State var startTime: Date?
    
    @Environment(\.dismiss) var dismiss
    
    let weights = Array(stride(from: 0, to: 999, by: 5))
    let reps = Array(2...100)
    
    @State private var rep_count = 12
    @State private var weight = 100
    
    func updateSetsLiveActivity(completed: Int, total: Int) {
        if let a = activity {
            var state = TimerAttributes.TimerStatus(startTime: startTime!, currentExercise: "--", sets_completed: completed, total_sets: total)
            
            if let exercise = vm.currentExercise {
                state = TimerAttributes.TimerStatus(startTime: startTime!, currentExercise: exercise, sets_completed: completed, total_sets: total)
            }
            
            Task {
                await a.update(using: state)
            }
        }
    }
    
    private func saveWorkout() {
        // kinda hacky but it works
        // routine.routine = observable object
        print(rep_count)
        print(weight)
        routineObj.routine.sets.append(WorkingSet(id: UUID(), weight: Double(weight), reps: rep_count, isCompleted: false))
        routineObj.sets.append(WorkingSet(id: UUID(), weight: Double(weight), reps: rep_count, isCompleted: false))
        routineObj.objectWillChange.send()
        vm.user.save()
        
        updateSetsLiveActivity(completed: routineObj.routine.getSetsCompleted(), total: routineObj.routine.sets.count)
        dismiss()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        HStack {
                            Picker("Sets", selection: $rep_count) {
                                Text("1 rep").tag(1)
                                ForEach(reps, id: \.self) { rep in
                                    Text("\(rep) reps").tag(rep)
                                }
                            }
                            .pickerStyle(.wheel)
                            Picker("Weight", selection: $weight) {
                                ForEach(weights, id: \.self) { weight in
                                    Text("\(weight) lbs").tag(weight)
                                }
                            }
                            .pickerStyle(.wheel)
                        }
                    }
                }
                Button(action: saveWorkout) {
                    Text("Save")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                }
                .foregroundColor(.white)
                .background(Color.pink)
                .cornerRadius(15)
                .padding()
            }
            .navigationTitle("Add Set")
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(UIColor.secondarySystemFill))
                }
            }
        }
    }
}

struct EditSingleExerciseView: View {
    @ObservedObject var routineObj: RoutineObj
    @ObservedObject var vm: ViewModel
    @Binding var index: Int
    
    @State var activity: Activity<TimerAttributes>?
    @State var startTime: Date?
    
    @Environment(\.dismiss) var dismiss
    
    let weights = Array(stride(from: 0, to: 999, by: 5))
    let reps = Array(2...100)
    
    @State private var rep_count = 12
    @State private var weight = 100
    
    func updateSetsLiveActivity(completed: Int, total: Int) {
        if let a = activity {
            var state = TimerAttributes.TimerStatus(startTime: startTime!, currentExercise: "--", sets_completed: completed, total_sets: total)
            
            if let exercise = vm.currentExercise {
                state = TimerAttributes.TimerStatus(startTime: startTime!, currentExercise: exercise, sets_completed: completed, total_sets: total)
            }
            
            Task {
                await a.update(using: state)
            }
        }
    }
    
    private func saveWorkout() {
        // kinda hacky but it works
        // routine.routine = observable object
        print(index)
        print(rep_count)
        print(weight)
        
        routineObj.routine.sets[index] = (WorkingSet(id: UUID(), weight: Double(weight), reps: rep_count, isCompleted: false))
        routineObj.sets[index] = (WorkingSet(id: UUID(), weight: Double(weight), reps: rep_count, isCompleted: false))
        vm.user.save()
        updateSetsLiveActivity(completed: routineObj.routine.getSetsCompleted(), total: routineObj.routine.sets.count)
        dismiss()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        HStack {
                            Picker("Sets", selection: $rep_count) {
                                Text("1 rep").tag(1)
                                ForEach(reps, id: \.self) { rep in
                                    Text("\(rep) reps").tag(rep)
                                }
                            }
                            .pickerStyle(.wheel)
                            Picker("Weight", selection: $weight) {
                                ForEach(weights, id: \.self) { weight in
                                    Text("\(weight) lbs").tag(weight)
                                }
                            }
                            .pickerStyle(.wheel)
                        }
                    }
                }
                Button(action: saveWorkout) {
                    Text("Save")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                }
                .foregroundColor(.white)
                .background(Color.pink)
                .cornerRadius(15)
                .padding()
            }
            .navigationTitle("Edit Set")
            .toolbar {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color(UIColor.secondarySystemFill))
                }
            }
        }
    }
}

struct SingleExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        SingleExerciseView(vm: ViewModel(), routine: RoutineObj(routine: Routine(id: 0, exercise: Exercise(id: 0, name: "Bench Press", description: "Push bar up", exercise_base: 0), sets: [WorkingSet(id: UUID(), weight: 123, reps: 12, isCompleted: false), WorkingSet(id: UUID(), weight: 123, reps: 12, isCompleted: false), WorkingSet(id: UUID(), weight: 123, reps: 12, isCompleted: false)]), sets: [WorkingSet(id: UUID(), weight: 123, reps: 12, isCompleted: false), WorkingSet(id: UUID(), weight: 123, reps: 12, isCompleted: false), WorkingSet(id: UUID(), weight: 123, reps: 12, isCompleted: false)]))

    }
}
