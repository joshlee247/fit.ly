//
//  LatestWorkoutGroupBoxStyle.swift
//  Final Project
//
//  Created by Josh Lee on 4/18/23.
//

import SwiftUI

// styling for latest workout

struct LatestWorkoutGroupBoxStyle<V: View>: GroupBoxStyle {
    var color: Color
    var destination: V
    var date: Date?

    @ScaledMetric var size: CGFloat = 1
    
    func makeBody(configuration: Configuration) -> some View {
        NavigationLink(destination: destination) {
            GroupBox(label: HStack {
                configuration.label.foregroundColor(color)
                // justify between Label + Time/Chevron
                Spacer()
                if let stamp = date {
                    if Calendar.current.isDateInToday(stamp) {
                        Text("\(stamp.formatted(date: .omitted, time: .shortened))").font(.footnote).foregroundColor(.secondary).padding(.trailing, 4)
                    } else if Calendar.current.isDateInYesterday(stamp) {
                        Text("Yesterday").font(.footnote).foregroundColor(.secondary).padding(.trailing, 4)
                    } else {
                        Text("\(stamp.formatted(date: .numeric, time: .omitted))").font(.footnote).foregroundColor(.secondary).padding(.trailing, 4)
                    }
                }
                Image(systemName: "chevron.right").foregroundColor(Color(.systemGray4)).imageScale(.small)
            }) {
                configuration.content.padding(.top, 3)
            }
        }.buttonStyle(PlainButtonStyle())
    }
}
