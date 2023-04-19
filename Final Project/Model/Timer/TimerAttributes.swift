//
//  TimerAttributes.swift
//  Final Project
//
//  Created by Josh Lee on 4/6/23.
//

import Foundation
import ActivityKit
import SwiftUI

struct TimerAttributes: ActivityAttributes {
    public typealias TimerStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var startTime: Date
    }
}
