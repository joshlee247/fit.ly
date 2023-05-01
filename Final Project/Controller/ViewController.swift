//
//  ViewController.swift
//  Final Project
//
//  Created by Josh Lee on 3/29/23.
//

import UIKit
import SwiftUI
import HealthKit
import ActivityKit

// 

class ViewModel: ObservableObject {
    
    // data members to update every change
    @Published var heartRateData: HealthDataPoint = HealthDataPoint(type: "Heart Rate", icon: "heart.fill", unit: "BPM", value: 0.0, time: Date.now, color: .pink)
    @Published var stepsCount: HealthDataPoint = HealthDataPoint(type: "Steps", icon: "flame.fill", unit: "steps", value: 0.0, time: Date.now, color: .orange)
    
    @Published var data: [HealthDataPoint] = [HealthDataPoint(type: "Heart Rate", icon: "heart.fill", unit: "BPM", value: 0.0, time: Date.now, color: .pink), HealthDataPoint(type: "Steps", icon: "flame.fill", unit: "steps", value: 0.0, time: Date.now, color: .orange), HealthDataPoint(type: "Active Energy", icon: "flame.fill", unit: "cal", value: 0.0, time: Date.now, color: .orange)]
    
    @Published var user = User.sharedInstance
    @Published var workouts = User.sharedInstance.workouts
    @Published var completedWorkouts = User.sharedInstance.completedWorkouts
    @Published var completedSets = User.sharedInstance.completedSets
    @Published var weather = WeatherReport(temp: 0, icon: [Conditions(id: 800, main: "Clear", description: "clear sky", icon: "01d")])
    @Published var startTime: Date? = nil
    @Published var activity: Activity<TimerAttributes>? = nil
    var currentExercise: String? = nil
    
    static let sharedInstance = ViewModel()
    
    func getCompletedWorkoutsThisWeek() -> [CompletedWorkout] {
        let calendar = Calendar.current
        return completedWorkouts.filter {
            calendar.isDate($0.date, equalTo: Date.now, toGranularity: .weekOfYear)
        }
    }
    
    func getPersonalBests() -> [CompletedSet] {
        var records: [CompletedSet] = []
        let groups = Array(Dictionary(grouping:completedSets){$0.exercise.name}.values)
        for group in groups {
            records.append(group.max { $0.weight < $1.weight }!)
        }
        return records
    }
}

class ViewController: UIViewController {

    let data = HealthData.sharedInstance
    var heartRateData = [HealthDataPoint]()
    var vm: ViewModel!
    var weatherModel = WeatherModel.shared
    
    func loadWeather() {
        self.weatherModel.getWeather(onSuccess: { weather in
            DispatchQueue.main.async {
                self.vm.weather = self.weatherModel.weather
            }
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // adding SummaryView (SwiftUI) into Storyboard
        self.vm = ViewModel.sharedInstance
        let contentView = SummaryView(vm: self.vm)
        let hostingController = UIHostingController(rootView: contentView)
        addChild(hostingController)
        view.insertSubview(hostingController.view, at: 0)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.didMove(toParent: self)
        
        self.loadWeather()
        
        // get health data from HealthKit
        if HKHealthStore.isHealthDataAvailable() {
            // heart rate
            data.getHeartRateData { (data, error) in
                if let error = error {
                    print("An error occurred while querying for heart rate data: \(error.localizedDescription)")
                    return
                }

                if let data = data {
                    self.heartRateData = data
                    if self.heartRateData.count != 0 {
                        DispatchQueue.main.async {
                            // update UI with heart rate data
                            contentView.updateHeartRate(heartRate: self.heartRateData[0])
                            contentView.vm.data[0] = self.heartRateData[0]
                        }
                    }
                }
            }
            // steps
            data.getStepsData { steps in
                DispatchQueue.main.async {
                    // update UI with heart steps data
                    contentView.updateStepCount(steps: steps)
                    contentView.vm.data[1] = steps
                }
            }
            
            // active energy
            data.getActiveCalsBurned { cals in
                DispatchQueue.main.async {
                    // update UI with calories data
                    contentView.vm.data[2] = cals
                }
            }
        }
    }
    
    // queries HealthKit data every time view loads
    override func viewWillAppear(_ animated: Bool) {
        self.loadWeather()
        
        // get health data from HealthKit
        if HKHealthStore.isHealthDataAvailable() {
            // heart rate
            data.getHeartRateData { (data, error) in
                if let error = error {
                    print("An error occurred while querying for heart rate data: \(error.localizedDescription)")
                    return
                }

                if let data = data {
                    self.heartRateData = data
                    if self.heartRateData.count != 0 {
                        DispatchQueue.main.async {
                            // Reload table view or update UI with heart rate data
                            self.vm.data[0] = self.heartRateData[0]
                        }
                    }
                }
            }
            // steps
            data.getStepsData { steps in
                DispatchQueue.main.async {
                    // Reload table view or update UI with heart rate data
                    self.vm.data[1] = steps
                }
            }
            
            // active energy
            data.getActiveCalsBurned { cals in
                DispatchQueue.main.async {
                    // Reload table view or update UI with heart rate data
                    self.vm.data[2] = cals
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
