//
//  ExerciseImage.swift
//  Final Project
//
//  Created by Josh Lee on 4/3/23.
//

import Foundation

// struct for wger.de API response
struct ExerciseImageResponse: Codable {
    let results: [ExerciseImage]
}

struct ExerciseImage: Codable {
    let image: String
}
