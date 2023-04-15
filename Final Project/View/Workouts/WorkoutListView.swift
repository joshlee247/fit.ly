//
//  WorkoutList.swift
//  Final Project
//
//  Created by Josh Lee on 3/31/23.
//

import SwiftUI
import Foundation
import ActivityKit

class ExerciseList: ObservableObject {
    @Published var workout: Workout
    @Published var routines: [Routine]
    @Published var user: User
    
    init(workout: Workout, routines: [Routine], user: User) {
        self.workout = workout
        self.routines = routines
        self.user = user
    }
}

struct ExerciseListView: View {
    @ObservedObject var routine: ExerciseList
    
    var body: some View {
        StoryBoardExerciseTableView(routine: routine)
    }
}

struct WorkoutListView: View {
    @ObservedObject var exerciseList: ExerciseList
    @ObservedObject var vm: ViewModel
    @ObservedObject var workout: Workout
    @State private var editMode = EditMode.inactive
    @State private var showSheet = false
    
    @State private var isStarted: Bool = false
    @State private var startTime: Date? = nil
    
    @State private var activity: Activity<TimerAttributes>? = nil
    
    private var addButton: some View {
        switch editMode {
        case .inactive:
            return AnyView(Button(action: onAdd) { Image(systemName: "plus") })
        default:
            return AnyView(EmptyView())
        }
    }
    
    private func onAdd() {
        showSheet = true
    }
    
    private func onDelete(offsets: IndexSet) {
        workout.routines.remove(atOffsets: offsets)
        vm.user.save()
    }

    // 3.
    private func onMove(source: IndexSet, destination: Int) {
        workout.routines.move(fromOffsets: source, toOffset: destination)
        vm.user.save()
    }
    
    func startTimer() {
        isStarted.toggle()
        
        if isStarted {
            startTime = .now
            // start live activity
            let attributes = TimerAttributes()
            let state = TimerAttributes.TimerStatus(startTime: .now)
            activity = try? Activity<TimerAttributes>.request(attributes: attributes, contentState: state, pushType: nil)
        } else {
            guard let startTime else { return }
            // stop live activity
            let state = TimerAttributes.TimerStatus(startTime: startTime)
            
            Task {
                await activity?.end(using: state, dismissalPolicy: .immediate)
            }
            
            self.startTime = nil
        }
    }

    func updateActivity() {
        let state = TimerAttributes.TimerStatus(startTime: .now)
        
        Task {
            await activity?.update(using: state)
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(workout.routines) { routine in
                    NavigationLink(destination: SingleExerciseView(vm: vm, routine: RoutineObj(routine: routine, sets: routine.sets))) {
                        HStack {
                            VStack {
                                Text(routine.sets.isEmpty ? "--" : "\(routine.sets[0].weight, specifier: "%.0f")")
                                .font(.system(size: 14, weight: .medium, design: .rounded))
                                Text("LBS")
                                .font(.system(size: 8, weight: .medium, design: .rounded))
                            }
                            .frame(width: 45, height: 45)
                            .foregroundColor(Color.white)
                            .multilineTextAlignment(.center)
                            .background(Color.pink)
                            .clipShape(Circle())
                            VStack(alignment: .leading) {
                                Text(routine.exercise.name).font(.system(size: 16, design: .rounded))
                                Text(routine.sets.isEmpty ? "--" :"\(routine.sets.count) sets, \(routine.sets[0].reps) reps").font(.footnote).foregroundColor(Color(.systemGray))
                            }.padding(8)
                        }
                    }
                }
                .onDelete(perform: onDelete)
            }
            Button(action: startTimer) {
                Text(isStarted ? "End Workout" : "Start Workout")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .font(.system(size: 18, weight: .semibold, design: .rounded))
            }
            .disabled(exerciseList.workout.routines.isEmpty)
            .foregroundColor(.white)
            .background(exerciseList.workout.routines.isEmpty ? Color(UIColor.tertiarySystemFill) : Color.pink)
            .cornerRadius(15)
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(exerciseList.workout.title)
        .sheet(isPresented: $showSheet, content: {
            ExerciseListView(routine: exerciseList)
        })
        .navigationBarItems(trailing: addButton)
    }
}

struct StoryBoardExerciseTableView: UIViewControllerRepresentable {
    @ObservedObject var routine: ExerciseList
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(identifier: "ExerciseTableView") as! WorkoutsTableViewController
        controller.routine = routine
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        // something
        
    }
}

struct WorkoutListView_Preview: PreviewProvider {
    static var previews: some View {
        WorkoutListView(exerciseList: ExerciseList(workout: Workout(title: "test", routines: [Routine(id: 0, exercise: Exercise(id: 0, name: "Push ups", description: "push up", exercise_base: 0), sets: [WorkingSet(id: UUID(), weight: 135, reps: 8, isCompleted: false), WorkingSet(id: UUID(), weight: 155, reps: 10, isCompleted: false), WorkingSet(id: UUID(), weight: 155, reps: 8, isCompleted: false)])]), routines: [Routine(id: 0, exercise: Exercise(id: 0, name: "Push ups", description: "push up", exercise_base: 0), sets: [WorkingSet(id: UUID(), weight: 135, reps: 8, isCompleted: false), WorkingSet(id: UUID(), weight: 155, reps: 10, isCompleted: false), WorkingSet(id: UUID(), weight: 155, reps: 8, isCompleted: false)])], user: User.sharedInstance), vm: ViewModel(), workout: Workout(title: "Test", routines: []))
    }
}

struct StartButtonStyle: ButtonStyle {
    var disabled = false
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(disabled ? Color(UIColor.systemGroupedBackground) : .pink)
    }
}
