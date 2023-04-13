//
//  User.swift
//  Final Project
//
//  Created by Josh Lee on 3/30/23.
//

import Foundation

let kWorkoutsArray = "WorkoutsArray"
let kWorkoutsJson = "Workouts.json"
// find the Documents directory
let url = manager.urls(for: .documentDirectory,
                       in: .userDomainMask).first

struct User: Codable {
    var workouts: [Workout] = []
    var isWorkingOut: Bool
    
    init() {
        if let filepath = url?.appendingPathComponent(kWorkoutsJson).path {
            print("filepath=\(filepath)")
            do {
                  let data = try Data(contentsOf: URL(fileURLWithPath: filepath), options: .mappedIfSafe)
                  let jsonResult = try? JSONDecoder().decode([Workout].self, from: data)
                  workouts = jsonResult!
            } catch {
                print(error)
            }
        }
        isWorkingOut = false
    }
    
    func save() {
        // Step 2: Use an encoder to encode
        let encoder = JSONEncoder()

        do {
            // Convert Swift to JSON (data)
            let data = try encoder.encode(workouts)
            let jsonString = String(data: data, encoding: .utf8)!
            let workoutsFilePath = "\(url!)/\(kWorkoutsJson)"
            
            try jsonString.write(to: URL(string: workoutsFilePath)!, atomically: true, encoding: .utf8)
        } catch {
            print(error)
        }
    }
    
    //    init() {
    //        let encoder = JSONEncoder()
    //
    //        do {
    //            // Convert Swift to JSON (data)
    //            let data = try encoder.encode(workouts)
    //
    //            // Convert JSON(data) into JSON(string)
    //            let jsonString = String(data: data, encoding: .utf8)!
    //
    //            let flashcardsFilePath = "\(url!)/\(kWorkoutsJson)"
    //            print(flashcardsFilePath)
    //
    //            try jsonString.write(to: URL(string: flashcardsFilePath)!, atomically: true, encoding: .utf8)
    //
    ////            UserDefaults.standard.set(data, forKey: kFlashcardsArrayKey)
    //        } catch {
    //            print(error)
    //        }
    //    }
    
    static let sharedInstance = User()
}
