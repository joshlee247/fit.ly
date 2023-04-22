//
//  TestChart.swift
//  Final Project
//
//  Created by Josh Lee on 4/21/23.
//

import SwiftUI
import Charts
import Foundation

struct CompletedWorkoutsChart: View {
    let workouts: [CompletedWorkout]
        
    var body: some View {
        VStack {
            GroupBox(label: Label("Average Workout Time", systemImage: "figure.strengthtraining.traditional").font(.system(size: 12, weight: .semibold, design: .rounded))) {
                Chart {
                    ForEach(workouts) { workout in
                        BarMark(
                            x: .value("Date", workout.date, unit: .day),
                            y: .value("Time Elapsed", workout.timeElapsed)
                        )
                    }
                }
                .chartXAxis {
                    AxisMarks(values: .stride(by: .day)) { value in
                        AxisValueLabel(format: .dateTime.weekday(), centered: true)
                    }
                }
                .frame(height: 200)
            }
        }
    }
}

struct CompletedWorkoutsChart_Previews: PreviewProvider {
    static var previews: some View {
        CompletedWorkoutsChart(workouts: [
            CompletedWorkout(date: "04192023", timeElapsed: TimeInterval(floatLiteral: 12.234152135)),
            CompletedWorkout(date: "04202023", timeElapsed: TimeInterval(floatLiteral: 113.13213)),
            CompletedWorkout(date: "04232023", timeElapsed: TimeInterval(floatLiteral: 65.241)),
            CompletedWorkout(date: "04242023", timeElapsed: TimeInterval(floatLiteral: 73.214)),
            CompletedWorkout(date: "04252023", timeElapsed: TimeInterval(floatLiteral: 40.213)),
            CompletedWorkout(date: "04262023", timeElapsed: TimeInterval(floatLiteral: 94.1235)),
            CompletedWorkout(date: "04272023", timeElapsed: TimeInterval(floatLiteral: 12.1515)),
            CompletedWorkout(date: "04282023", timeElapsed: TimeInterval(floatLiteral: 31.5213))
        ])
    }
}
