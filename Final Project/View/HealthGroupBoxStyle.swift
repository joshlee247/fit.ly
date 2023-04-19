//
//  HealthGroupBoxStyle.swift
//  Final Project
//
//  Created by Josh Lee on 3/30/23.
//

import SwiftUI

struct HealthGroupBoxStyle<V: View>: GroupBoxStyle {
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
                if date != nil {
                    Text("\(date!.formatted(date: .omitted, time: .shortened))").font(.footnote).foregroundColor(.secondary).padding(.trailing, 4)
                }
                Image(systemName: "chevron.right").foregroundColor(Color(.systemGray4)).imageScale(.small)
            }) {
                configuration.content.padding(.top, 3)
            }
        }.buttonStyle(PlainButtonStyle())
    }
}
