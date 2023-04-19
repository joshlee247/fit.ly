//
//  ExerciseModel.swift
//  Final Project
//
//  Created by Josh Lee on 3/30/23.
//

import Foundation

let kExercisesArrayKey = "ExercisesArray"
let kExercisesJson = "Exercises.json"
// find the Documents directory
let manager = FileManager.default
let jsonUrl = manager.urls(for: .documentDirectory,
                       in: .userDomainMask).first

class ExerciseModel {
    static let shared = ExerciseModel()
    var exercises: [Exercise] = []
    
    let ACCESS_KEY = "94b9f1d21f0b74b3f8674480a8bbebaec4fad7e0"
    let BASE_URL = "https://wger.de/"
    
    func getExercises(onSuccess: @escaping ([Exercise]) -> Void) {
        print("called getExercises")
        if let filepath = jsonUrl?.appendingPathComponent(kExercisesJson).path {
            print("filepath=\(filepath)")
            do {
                print("JSON available")
                  let data = try Data(contentsOf: URL(fileURLWithPath: filepath), options: .mappedIfSafe)
                  let jsonResult = try? JSONDecoder().decode([Exercise].self, from: data)
                  exercises = jsonResult!
            } catch {
                print("No JSON available")
                if let url = URL(string: "\(BASE_URL)api/v2/exercise/?limit=999&language=2") {
                    var urlRequest = URLRequest(url: url)
                    urlRequest.setValue("Token \(ACCESS_KEY)", forHTTPHeaderField: "Authorization")
                    URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                        if let data = data {
                            do {
                                print("Getting exercises...")
                                let res = try JSONDecoder().decode(Response.self, from: data)
                                self.exercises = res.results
                                print(self.exercises.count)
                                onSuccess(self.exercises)
                                // Convert Swift to JSON (data)
                                print("Saving exercises to JSON")
                                let encoder = JSONEncoder()
                                let data = try encoder.encode(self.exercises)
                                // Convert JSON(data) into JSON(string)
                                let jsonString = String(data: data, encoding: .utf8)!
                                let exercisesFilepath = "\(jsonUrl!)/\(kExercisesJson)"
                                try jsonString.write(to: URL(string: exercisesFilepath)!, atomically: true, encoding: .utf8)
                                print("Saved exercises to JSON \(exercisesFilepath)")
                            } catch let error {
                                print(error)
                                // Handle decoding error...
                                exit(1)
                            }
                        }
                    }.resume()
                }
            }
        }
    }
    
    func getExercise(at: Int) -> Exercise? {
        return exercises[at]
    }
    
    func numberOfExercises() -> Int {
        return exercises.count
    }
}
