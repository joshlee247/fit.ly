//
//  ViewController.swift
//  Final Project
//
//  Created by Josh Lee on 3/29/23.
//

import UIKit
import SwiftUI
import HealthKit

class WorkoutsViewController: UIViewController {

    let data = HealthData()
//    var heartRateData = [HeartRateData]()
    private var vm: ViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        addChild(contentView)
//        view.addSubview(contentView.view)
        self.vm = ViewModel()
        let contentView = WorkoutsView(vm: self.vm)
        let hostingController = UIHostingController(rootView: contentView)
        addChild(hostingController)
        view.insertSubview(hostingController.view, at: 0)
        hostingController.view.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        hostingController.didMove(toParent: self)
    
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
