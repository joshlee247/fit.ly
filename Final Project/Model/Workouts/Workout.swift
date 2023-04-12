//
//  Workout.swift
//  Final Project
//
//  Created by Josh Lee on 3/31/23.
//

import Foundation

struct Workout: Identifiable, Codable {
    var id = UUID()
    
    var title: String
    var routines: [Routine]
    
    func to_string() -> String {
        var s = ""
        for routine in routines {
            s += routine.exercise.name
            s += ", "
        }
        return s
    }
}
