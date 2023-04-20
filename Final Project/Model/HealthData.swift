//
//  authorizeHealthKit.swift
//  Final Project
//
//  Created by Josh Lee on 3/30/23.
//

import Foundation
import HealthKit
import SwiftUI

struct HealthDataPoint: Identifiable {
    let id = UUID()
    
    let type: String
    let icon: String
    let unit: String
    let value: Double
    let time: Date
    let color: Color
}

struct HealthData {
    static let sharedInstance = HealthData()
    
    var currentHeartRate: Double = 0
    
    let healthStore: HKHealthStore = HKHealthStore()
    
    let allTypes = Set([HKObjectType.workoutType(),
                        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                        HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                        HKObjectType.quantityType(forIdentifier: .heartRate)!])
    
    init() {
        let write: Set<HKSampleType> = [HKObjectType.workoutType(),
                                        HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                                        HKObjectType.quantityType(forIdentifier: .distanceCycling)!,
                                        HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                                        HKObjectType.quantityType(forIdentifier: .heartRate)!]
        let read: Set = [
            HKObjectType.workoutType(),
            HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKObjectType.quantityType(forIdentifier: .stepCount)!,
            HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKObjectType.quantityType(forIdentifier: .heartRate)!
        ]

        healthStore.requestAuthorization(toShare: write, read: read) { success, error in
            if success {
                print("HEALTH DATA AUTHORIZED")
            } else {
                print("HEALTH NOT AUTHORIZED")
            }
        }
    }
    
    func getHeartRateData(completion: @escaping ([HealthDataPoint]?, Error?) -> Void) {
        let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate)!

        let startDate = Date().addingTimeInterval(-86400) // 24 hours ago
        let endDate = Date()

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])

        let queryHeartRate = HKSampleQuery(sampleType: heartRateType, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: [NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)]) { (query, results, error) in
            guard let results = results as? [HKQuantitySample] else {
                completion(nil, error)
                return
            }

            var heartRateData = [HealthDataPoint]()

            for sample in results {
                let heartRateUnit = HKUnit(from: "count/min")
                let heartRate = sample.quantity.doubleValue(for: heartRateUnit)
                let time = sample.startDate

                let data = HealthDataPoint(type: "Heart Rate", icon: "heart.fill", unit: "BPM", value: heartRate, time: time, color: .pink)
                heartRateData.append(data)
                print("appending new data: \(data)")
            }

            completion(heartRateData, nil)
        }
        HKHealthStore().execute(queryHeartRate)
    }
    
    func getStepsData(completion: @escaping (HealthDataPoint) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
            
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )
        
        let query = HKStatisticsQuery(
            quantityType: stepsQuantityType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(HealthDataPoint(type: "Steps", icon: "flame.fill", unit: "steps", value: 0.0, time: now, color: .orange))
                return
            }
            completion(HealthDataPoint(type: "Steps", icon: "flame.fill", unit: "steps", value: sum.doubleValue(for: HKUnit.count()), time: now, color: .orange))
        }
        HKHealthStore().execute(query)
    }
    
    func getActiveCalsBurned(completion: @escaping (HealthDataPoint) -> Void) {
        let activeCalsType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!
            
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        let predicate = HKQuery.predicateForSamples(
            withStart: startOfDay,
            end: now,
            options: .strictStartDate
        )
        
        let query = HKStatisticsQuery(
            quantityType: activeCalsType,
            quantitySamplePredicate: predicate,
            options: .cumulativeSum
        ) { _, result, _ in
            guard let result = result, let sum = result.sumQuantity() else {
                completion(HealthDataPoint(type: "Active Energy", icon: "flame.fill", unit: "cal", value: 0.0, time: now, color: .orange))
                return
            }
            completion(HealthDataPoint(type: "Active Energy", icon: "flame.fill", unit: "cal", value: sum.doubleValue(for: HKUnit.largeCalorie()), time: now, color: .orange))
        }
        HKHealthStore().execute(query)
    }
}
