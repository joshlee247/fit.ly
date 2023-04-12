//
//  Routine.swift
//  Final Project
//
//  Created by Josh Lee on 4/3/23.
//

import Foundation

struct Routine: Identifiable, Codable {
    var id: Int
    let exercise: Exercise
    var sets: Int
    var reps: Int
    var weight: Double
}
