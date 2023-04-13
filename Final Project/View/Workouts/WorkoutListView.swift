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
    
    init(workout: Workout) {
        self.workout = workout
    }
}

struct ExerciseListView: View {
    @ObservedObject var routine: ExerciseList
    
    var body: some View {
        StoryBoardExerciseTableView(routine: routine)
    }
}

struct WorkoutListView: View {
    @ObservedObject var routine: ExerciseList
    @ObservedObject var vm: ViewModel
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
        routine.workout.routines.remove(atOffsets: offsets)
        vm.user.save()
    }

    // 3.
    private func onMove(source: IndexSet, destination: Int) {
        routine.workout.routines.move(fromOffsets: source, toOffset: destination)
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
                ForEach(routine.workout.routines) { routine in
                    HStack {
                        Button(action: {
                            print("Round Action")
                            }) {
                                VStack {
                                    Text("\(routine.weight, specifier: "%.0f")")
                                    .font(.system(size: 14, weight: .medium, design: .rounded))
                                    Text("LBS")
                                    .font(.system(size: 8, weight: .medium, design: .rounded))
                                }
                                .frame(width: 45, height: 45)
                                .foregroundColor(Color.white)
                                .multilineTextAlignment(.center)
                                .background(Color.pink)
                                .clipShape(Circle())
                        }
                        VStack(alignment: .leading) {
                            Text(routine.exercise.name).font(.system(size: 16, design: .rounded))
                            Text("\(routine.sets) sets, \(routine.reps) reps").font(.footnote).foregroundColor(Color(.systemGray))
                        }.padding(8)
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
            .disabled(routine.workout.routines.isEmpty)
            .foregroundColor(.white)
            .background(routine.workout.routines.isEmpty ? Color(UIColor.tertiarySystemFill) : Color.pink)
            .cornerRadius(15)
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle(routine.workout.title)
        .sheet(isPresented: $showSheet, content: {
            ExerciseListView(routine: routine)
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
        WorkoutListView(routine: ExerciseList(workout: User.sharedInstance.workouts[0]), vm: ViewModel())
    }
}

struct StartButtonStyle: ButtonStyle {
    var disabled = false
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .background(disabled ? Color(UIColor.systemGroupedBackground) : .pink)
    }
}
