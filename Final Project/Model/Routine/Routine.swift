//
//  Routine.swift
//  Final Project
//
//  Created by Josh Lee on 4/3/23.
//

import Foundation

class Routine: Identifiable, Codable, ObservableObject {
    var id: Int
    let exercise: Exercise
    var sets: [WorkingSet]
    
    init(id: Int, exercise: Exercise, sets: [WorkingSet]) {
        self.id = id
        self.exercise = exercise
        self.sets = sets
    }
}

class WorkingSet: Identifiable, Codable, ObservableObject {
    var id: UUID
    var weight: Double
    var reps: Int
    var isCompleted: Bool
    
    init(id: UUID, weight: Double, reps: Int, isCompleted: Bool) {
        self.id = UUID()
        self.weight = weight
        self.reps = reps
        self.isCompleted = false
    }
}
