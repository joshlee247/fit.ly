//
//  Exercise.swift
//  Final Project
//
//  Created by Josh Lee on 3/30/23.
//

import Foundation

struct Response: Decodable {
    var results: [Exercise]
}

struct Exercise: Codable, Identifiable {
    var id: Int
    
    let name: String
    let description: String
    let exercise_base: Int
}


