//
//  SwiftUIView.swift
//  Final Project
//
//  Created by Josh Lee on 3/29/23.
//

import SwiftUI

struct SummaryView: View {
    @ObservedObject var vm: ViewModel
    
    func updateStepCount(steps: HealthDataPoint) {
        vm.stepsCount = steps
    }
    
    func updateHeartRate(heartRate: HealthDataPoint) {
        print("Updating heart rate")
        vm.heartRateData = heartRate
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                GroupBox(label: Text("Los Angeles").font(.system(size: 14, weight: .semibold, design: .rounded))) {
                    HStack {
                        if vm.weather.temp == 0 {
                            Text("--°").font(.system(size: 44, weight: .regular, design: .rounded))
                        } else {
                            Text("\(Int(vm.weather.temp))°").font(.system(size: 44, weight: .regular, design: .rounded))
                            AsyncImage(url: URL(string: "https://openweathermap.org/img/wn/\(vm.weather.icon[0].icon)@2x.png")) { image in image.resizable() } placeholder: { Color.clear } .frame(width: 50, height: 50) .clipShape(RoundedRectangle(cornerRadius: 100))
                        }
                    }
                }
                .groupBoxStyle(TransparentGroupBox())
                .foregroundColor(.white)
                .padding(.horizontal)
                VStack(spacing: 8) {
                    ForEach(vm.data) { data in
                        GroupBox(label: Label(data.type, systemImage: data.icon).font(.system(size: 12, weight: .semibold, design: .rounded))) {
                            HealthValueView(value: "\(Int(data.value))", unit: data.unit)
                        }.groupBoxStyle(HealthGroupBoxStyle(color: data.color, destination: Text("\(data.type)"), date: data.time))
                    }
                }.padding()
            }
            .background(Color(.systemGroupedBackground)).edgesIgnoringSafeArea(.bottom)
            .navigationTitle("Summary")
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let vm = ViewModel()
        SummaryView(vm: vm)
    }
}
