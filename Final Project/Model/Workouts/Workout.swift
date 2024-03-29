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
    
    init(date: Date, timeElapsed: TimeInterval) {
        self.date = date
        self.timeElapsed = timeElapsed
    }
}
