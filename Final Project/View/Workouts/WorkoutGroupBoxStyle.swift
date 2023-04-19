//
//  HealthGroupBoxStyle.swift
//  Final Project
//
//  Created by Josh Lee on 3/30/23.
//

import SwiftUI

struct WorkoutGroupBox<V: View>: GroupBoxStyle {
    var color: Color
    var destination: V
    var date: Date?

    @ScaledMetric var size: CGFloat = 1
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            NavigationLink(destination: destination) {
                HStack {
                    configuration.label
                        .foregroundColor(color)
                        .frame(maxWidth: 200)
                    // justify between Label + Time/Chevron
                    Spacer()
                }
            }
            configuration.content.padding(.top, 1)
        }
        .padding(.vertical, 2)
    }
}
