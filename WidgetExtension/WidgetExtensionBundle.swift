//
//  WidgetExtensionBundle.swift
//  WidgetExtension
//
//  Created by Josh Lee on 4/5/23.
//

import WidgetKit
import SwiftUI

@main
struct WidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        WidgetExtension()
        WidgetExtensionLiveActivity()
    }
}
