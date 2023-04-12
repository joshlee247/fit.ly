//
//  LiveActivityWidgetBundle.swift
//  LiveActivityWidget
//
//  Created by Josh Lee on 4/5/23.
//

import WidgetKit
import SwiftUI

@main
struct LiveActivityWidgetBundle: WidgetBundle {
    var body: some Widget {
        LiveActivityWidget()
        LiveActivityWidgetLiveActivity()
    }
}
