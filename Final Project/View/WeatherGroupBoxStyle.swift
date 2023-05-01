//
//  WeatherGroupBoxStyle.swift
//  Final Project
//
//  Created by Josh Lee on 4/5/23.
//

import SwiftUI



struct WeatherGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            HStack {
                configuration.label
                    .font(.headline)
                Spacer()
            }
            
            configuration.content
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 8, style: .continuous)
        .fill(LinearGradient(gradient: Gradient(colors: [.blue, Color(uiColor: UIColor(red: 148/255, green: 212/255, blue: 255/255, alpha: 1))]), startPoint: .leading, endPoint: .trailing))) // Set your color here!!
    }
}

