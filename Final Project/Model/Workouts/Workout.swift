//
//  Workout.swift
//  Final Project
//
//  Created by Josh Lee on 3/31/23.
//

import Foundation

class Workout: Identifiable, Codable, ObservableObject {
    var id = UUID()
    
    var title: String
    var routines: [Routine]
    
    init(title: String, routines: [Routine]) {
        self.title = title
        self.routines = routines
    }
    
    func to_string() -> String {
        var s = ""
        for routine in routines {
            s += routine.exercise.name
            s += ", "
        }
        return s
    }
}

class CompletedWorkout: Identifiable, Codable, ObservableObject {
    var date: Date
    let timeElapsed: TimeInterval
    
    init() {
        self.date = .now
        self.timeElapsed = 0
    }
    
    init(date: Date, timeElapsed: TimeInterval) {
        self.date = date
        self.timeElapsed = timeElapsed
    }
    
    // constructor for preview debugging
    init(date: String, timeElapsed: TimeInterval) {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMddyyyy"
        self.date = formatter.date(from: date) ?? Date.distantPast
        self.timeElapsed = timeElapsed
    }
}

class CompletedSet: Identifiable, Codable, ObservableObject {
    var date: Date
    let exercise: Exercise
    let weight: Double
    let reps: Int
    
    init(date: Date, exercise: Exercise, weight: Double, reps: Int) {
        self.date = date
        self.exercise = exercise
        self.weight = weight
        self.reps = reps
    }
}
