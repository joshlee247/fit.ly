//
//  TestChart.swift
//  Final Project
//
//  Created by Josh Lee on 4/21/23.
//

import SwiftUI
import Charts
import Foundation

// displays Average Workout Time Chart

struct CompletedWorkoutsChart: View {
    let workouts: [CompletedWorkout]
        
    var body: some View {
        VStack {
            GroupBox(label: Label("Average Workout Time", systemImage: "figure.strengthtraining.traditional").font(.system(size: 12, weight: .semibold, design: .rounded)).foregroundColor(.pink)) {
                VStack(alignment: .leading) {
                    let average = workouts.map {
                        $0.timeElapsed / 60
                    }
                    .reduce(0.0, +) / Double(workouts.count)
                    Text("You averaged \(average, format: .number.precision(.fractionLength(0))) minutes of exercise per workout this week.").font(.system(size: 12, weight: .semibold, design: .rounded))
                        .padding(.vertical, 2)
                    Divider()
                    ZStack(alignment: .leading) {
                        Chart {
                            let pastWeek = workouts.suffix(7)
                            ForEach(pastWeek) { workout in
                                BarMark(
                                    x: .value("Date", workout.date, unit: .day),
                                    y: .value("Time Elapsed", workout.timeElapsed)
                                )
                                .foregroundStyle(.black)
                                .opacity(0.2)
//                                #DEBUG
//                                .annotation(position: .overlay, alignment: .topLeading, spacing: 3) {
//                                    Text("\(workout.timeElapsed)")
//                                }
                            }
                        }
                        .chartXAxis {
                            AxisMarks(values: .stride(by: .day)) { value in
                                AxisValueLabel(format: .dateTime.weekday(.narrow), centered: true)
                            }
                        }
                        .chartYAxis {
                            
                        }
                        .frame(height: 200)
                        .padding(.leading, 150)
                        .padding(.vertical)
                        
                        VStack(alignment: .leading) {
                            HStack {
                                Text("\(average, format: .number.precision(.fractionLength(0)))").font(.system(size: 28, weight: .semibold, design: .rounded)) + Text(" mins").font(.system(size: 14, weight: .semibold, design: .rounded)).foregroundColor(.secondary)
                            }
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(.pink)
                                .frame(height: 5)
                                .padding(.top, -16)
                        }
                    }
                }
            }.groupBoxStyle(LatestWorkoutGroupBoxStyle(color: Color(UIColor.green), destination: Text("Latest Workout"), date: nil))
        }
    }
}

func getCompletedWorkoutsThisWeek(workouts: [CompletedWorkout]) -> [CompletedWorkout] {
    let calendar = Calendar.current
    return workouts.filter {
        calendar.isDate($0.date, equalTo: Date.now, toGranularity: .weekOfYear)
    }
}

struct CompletedWorkoutsChart_Previews: PreviewProvider {
    static let workouts = [
        CompletedWorkout(date: "04082023", timeElapsed: TimeInterval(floatLiteral: 900)),
        CompletedWorkout(date: "04242023", timeElapsed: TimeInterval(floatLiteral: 7200)),
        CompletedWorkout(date: "04242023", timeElapsed: TimeInterval(floatLiteral: 3600)),
        CompletedWorkout(date: "04242023", timeElapsed: TimeInterval(floatLiteral: 2700)),
        CompletedWorkout(date: "04292023", timeElapsed: TimeInterval(floatLiteral: 1800))
    ]
    
    static var previews: some View {
        CompletedWorkoutsChart(workouts: getCompletedWorkoutsThisWeek(workouts: workouts))
    }
}
