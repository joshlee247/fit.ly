//
//  TimerAttributes.swift
//  Final Project
//
//  Created by Josh Lee on 4/6/23.
//

import Foundation
import ActivityKit
import SwiftUI

// Attributes to update on Live Activity

struct TimerAttributes: ActivityAttributes {
    public typealias TimerStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var startTime: Date
        var currentExercise: String?
        var sets_completed: Int?
        var total_sets: Int?
        var heartRate: Double?
    }
}
