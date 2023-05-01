//
//  User.swift
//  Final Project
//
//  Created by Josh Lee on 3/30/23.
//

import Foundation

let kWorkoutsArray = "WorkoutsArray"
let kWorkoutsJson = "Workouts.json"
let kCompletedWorkoutsJson = "CompletedWorkouts.json"
let kCompletedSetsJson = "CompletedSets.json"
// find the Documents directory
let url = manager.urls(for: .documentDirectory,
                       in: .userDomainMask).first

class User: Codable, ObservableObject {
    var workouts: [Workout] = []
    var completedWorkouts: [CompletedWorkout] = []
    var completedSets: [CompletedSet] = []
    var isWorkingOut: Bool
    
//    #DEBUG
//    init() {
//        workouts = [
//            Workout(title: "Test", routines: [Routine(id: 0, exercise: Exercise(id: 0, name: "Test", description: "Test", exercise_base: 0), sets: [WorkingSet(id: UUID(), weight: 123, reps: 12, isCompleted: false), WorkingSet(id: UUID(), weight: 123, reps: 12, isCompleted: false), WorkingSet(id: UUID(), weight: 123, reps: 12, isCompleted: false)])])
//        ]
//        isWorkingOut = false
//        save()
//    }
//
    init() {
        // retrieves User's saved workout data from JSON file for faster load times
        // data stored on device for privacy reasons
        if let filepath = url?.appendingPathComponent(kWorkoutsJson).path {
            print("filepath=\(filepath)")
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filepath), options: .mappedIfSafe)
                let jsonResult = try? JSONDecoder().decode([Workout].self, from: data)
                if let res = jsonResult {
                    workouts = res
                } else {
                    workouts = []
                }
            } catch {
                print(error)
            }
        }
        
        // retrieves User's completed workouts from JSON file
        if let filepath = url?.appendingPathComponent(kCompletedWorkoutsJson).path {
            print("filepath=\(filepath)")
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filepath), options: .mappedIfSafe)
                let jsonResult = try? JSONDecoder().decode([CompletedWorkout].self, from: data)
                if let res = jsonResult {
                    completedWorkouts = res
                } else {
                    completedWorkouts = []
                }
            } catch {
                print(error)
            }
        }
        
        // retrieves User's completed sets from JSON file
        if let filepath = url?.appendingPathComponent(kCompletedSetsJson).path {
            print("filepath=\(filepath)")
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filepath), options: .mappedIfSafe)
                let jsonResult = try? JSONDecoder().decode([CompletedSet].self, from: data)
                if let res = jsonResult {
                    completedSets = res
                } else {
                    completedSets = []
                }
            } catch {
                print(error)
            }
        }
        
        isWorkingOut = false
        
        // reset all sets in each workout/routine
        for workout in workouts {
            for routine in workout.routines {
                for workingSet in routine.sets {
                    workingSet.isCompleted = false
                }
            }
        }
    }
    
    // save current user's session's data to file
    func save() {
        let encoder = JSONEncoder()

        do {
            // Convert Swift to JSON (data)
            let data = try encoder.encode(workouts)
            let jsonString = String(data: data, encoding: .utf8)!
            let workoutsFilePath = "\(url!)/\(kWorkoutsJson)"
            print(workoutsFilePath)
            try jsonString.write(to: URL(string: workoutsFilePath)!, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
        
        do {
            // Convert Swift to JSON (data)
            let data = try encoder.encode(completedWorkouts)
            let jsonString = String(data: data, encoding: .utf8)!
            let completedWorkoutsFilePath = "\(url!)/\(kCompletedWorkoutsJson)"
            print(completedWorkoutsFilePath)
            try jsonString.write(to: URL(string: completedWorkoutsFilePath)!, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
        
        do {
            // Convert Swift to JSON (data)
            let data = try encoder.encode(completedSets)
            let jsonString = String(data: data, encoding: .utf8)!
            let completedSetsFilePath = "\(url!)/\(kCompletedSetsJson)"
            print(completedSetsFilePath)
            try jsonString.write(to: URL(string: completedSetsFilePath)!, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }
    
    static let sharedInstance = User()
}
