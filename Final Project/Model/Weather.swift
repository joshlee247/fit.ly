//
//  Weather.swift
//  Final Project
//
//  Created by Josh Lee on 4/5/23.
//

import Foundation

struct WeatherResponse: Codable {
    let main: Weather
    let weather: [Conditions]
}

struct Weather: Codable {
    let temp: Double
}

struct Conditions: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct WeatherReport {
    let temp: Double
    let icon: [Conditions]
}
