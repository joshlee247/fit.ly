//
//  ExerciseDetailViewController.swift
//  Final Project
//
//  Created by Josh Lee on 4/3/23.
//

import UIKit
import WebKit

let ACCESS_KEY = "94b9f1d21f0b74b3f8674480a8bbebaec4fad7e0"
let BASE_URL = "https://wger.de/"

class ExerciseDetailViewController: UIViewController, WKNavigationDelegate {
    
    @IBOutlet weak var WKView: WKWebView!
    
    @IBOutlet weak var ActivityIndicator: UIActivityIndicatorView!
    
    var selectedExercise: Exercise!
    var image_url: String = ""
    
    @IBOutlet weak var ExerciseTitle: UILabel!
    
    func getImageURL(onSuccess: @escaping (String) -> Void) {
        // Do any additional setup after loading the view.
        if let url = URL(string: "\(BASE_URL)api/v2/exerciseimage/?exercise_base=\(selectedExercise.exercise_base)&limit=1") {
            var urlRequest = URLRequest(url: url)
            urlRequest.setValue("Token \(ACCESS_KEY)", forHTTPHeaderField: "Authorization")
            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                if let data = data {
                    do {
                        print("Getting exercise image...")
                        let res = try JSONDecoder().decode(ExerciseImageResponse.self, from: data)
                        if !res.results.isEmpty {
                            self.image_url = res.results[0].image
                        } else {
                            self.image_url = "https://propertywiselaunceston.com.au/wp-content/themes/property-wise/images/no-image@2x.png"
                        }
                        onSuccess(self.image_url)
                    } catch let error {
                        print(error)
                        self.image_url = "https://propertywiselaunceston.com.au/wp-content/themes/property-wise/images/no-image@2x.png"
                    }
                }
            }.resume()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WKView.navigationDelegate = self
        ExerciseTitle.text = selectedExercise.name
        
        self.getImageURL(onSuccess: { url in
            DispatchQueue.main.async {
                self.image_url = url
                
                if let myURL = URL(string: self.image_url) {
                    let myRequest = URLRequest(url: myURL)
                    self.WKView.load(myRequest)
                }
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if WKView.isLoading {
            WKView.stopLoading()
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        ActivityIndicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish: WKNavigation!) {
        ActivityIndicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        ActivityIndicator.stopAnimating()
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
