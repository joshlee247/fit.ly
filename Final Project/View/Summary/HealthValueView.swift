//
//  HealthValueView.swift
//  Final Project
//
//  Created by Josh Lee on 3/30/23.
//

import SwiftUI

struct HealthValueView: View {
    var value: String
    var unit: String
    
    @ScaledMetric var size: CGFloat = 1
    
    @ViewBuilder var body: some View {
        HStack {
            Text(value).font(.system(size: 24 * size, weight: .semibold, design: .rounded)) + Text(" \(unit)").font(.system(size: 14 * size, weight: .semibold, design: .rounded)).foregroundColor(.secondary)
            Spacer()
        }
    }
}

struct HealthValueView_Previews: PreviewProvider {
    static var previews: some View {
        HealthValueView(value: "69", unit: "BPM")
    }
}
