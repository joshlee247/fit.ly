//
//  PersonalBestView.swift
//  Final Project
//
//  Created by Josh Lee on 4/23/23.
//

import SwiftUI

struct PersonalBestView: View {
    @State var best: CompletedSet
    
    var body: some View {
        VStack {
            GroupBox(label: Label("\(best.exercise.name)", systemImage: "dumbbell.fill").font(.system(size: 12, weight: .semibold, design: .rounded)).foregroundColor(.pink)) {
                HStack {
                    HealthValueView(value: "\(best.weight)", unit: "lbs")
                }
            }
            .groupBoxStyle(LatestWorkoutGroupBoxStyle(color: Color(UIColor.green), destination: Text("Latest Workout"), date: best.date))
        }
    }
}

struct PersonalBestView_Previews: PreviewProvider {
    static var previews: some View {
        PersonalBestView(best: CompletedSet(date: Date.now, exercise: Exercise(id: 0, name: "Bench Press", description: "description", exercise_base: 1), weight: 100, reps: 10))
    }
}
