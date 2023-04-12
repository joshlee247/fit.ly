//
//  WorkoutModel.swift
//  Final Project
//
//  Created by Josh Lee on 3/31/23.
//

import Foundation

class WorkoutModel {
    static let shared = WorkoutModel()
    var workouts: [Workout] = []

    func addWorkout(workout: Workout) {
        workouts.append(workout)
    }
    
    func deleteWorkout(index: Int) {
        workouts.remove(at: index)
    }
    
    func editWorkout(index: Int, workout: Workout) {
        workouts[index] = workout
    }
}
