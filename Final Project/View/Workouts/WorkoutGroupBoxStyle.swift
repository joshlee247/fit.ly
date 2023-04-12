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
            HStack {
                configuration.label
                    .foregroundColor(color)
                    .frame(maxWidth: 200)
                // justify between Label + Time/Chevron
                Spacer()
                NavigationLink(destination: destination) {
                    Image(systemName: "chevron.right").foregroundColor(Color(.systemGray4)).imageScale(.small)
                }
                .buttonStyle(.plain)
                .controlSize(.large)
            }
            NavigationLink(destination: destination) {
                configuration.content.padding(.top, 1)
            }
        }
        .padding()
        .background(colorScheme == .dark ? Color(UIColor.tertiarySystemFill) : Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}
