//
//  WidgetExtensionLiveActivity.swift
//  WidgetExtension
//
//  Created by Josh Lee on 4/5/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct WidgetExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var value: Int
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct RoundedRectProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 14)
                .frame(width: .infinity, height: 5)
                .foregroundColor(Color(UIColor.systemGray5))
            
            RoundedRectangle(cornerRadius: 14)
                .frame(width: CGFloat(configuration.fractionCompleted ?? 0) * 340, height: 5)
                .foregroundColor(.pink)
        }
    }
}

struct WorkoutActivityView: View {
    @State private var workoutProgress = 0.0
    @State private var animationAmount = 1.0
    @Environment(\.colorScheme) var colorScheme
    
    let context: ActivityViewContext<TimerAttributes>
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Image("logo")
                .resizable()
                .frame(width: 25, height: 25)
                .cornerRadius(6)
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(Color(UIColor.systemGray4), lineWidth: 1)
                )
            HStack {
                HStack {
                    Image(systemName: "heart.fill")
                        .font(Font.system(.subheadline).bold()).foregroundColor(.pink)
                        .frame(width: 10)
                        .padding(.leading, 2)
                        .shadow(color: .pink, radius: 3)
            
                    Text("56").font(.system(size: 24, weight: .semibold, design: .rounded)) + Text(" BPM").font(.system(size: 14, weight: .semibold, design: .rounded)).foregroundColor(.secondary)
                }
                Spacer()
                Text(context.state.startTime, style: .timer).font(.system(size: 36, weight: .semibold, design: .rounded))
                    .multilineTextAlignment(.trailing)
            }
            HStack {
                Label("Bench Press", systemImage: "dumbbell.fill").font(.system(size: 12, weight: .semibold, design: .rounded)).foregroundColor(.pink)
                Spacer()
                Text("2 sets remaining").font(.system(size: 12, weight: .regular, design: .rounded)).foregroundColor(Color(UIColor.systemGray))
            }
            ProgressView("Downloading…", value: 50, total: 100)
        }
        .progressViewStyle(RoundedRectProgressViewStyle())
        .activityBackgroundTint(colorScheme == .dark ? Color.black : Color.white)
        .activitySystemActionForegroundColor(Color.black)
        .padding()

    }
}

struct WidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerAttributes.self) { context in
            // Lock screen/banner UI goes here
            WorkoutActivityView(context: context)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
//                    Text("Leading")
                    HStack {
                        HStack {
                            Image(systemName: "heart.fill")
                                .font(Font.system(.subheadline).bold()).foregroundColor(.pink)
                                .frame(width: 10)
                                .padding(.leading, 2)
                                .shadow(color: .pink, radius: 3)
                            Text("56").font(.system(size: 24, weight: .semibold, design: .rounded)) + Text(" BPM").font(.system(size: 14, weight: .semibold, design: .rounded)).foregroundColor(.secondary)
                        }
                        .padding(.leading)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
//                    Text("Trailing")
                    Text(context.state.startTime, style: .timer).font(.system(size: 36, weight: .semibold, design: .rounded))
                        .multilineTextAlignment(.trailing)
                        .padding(.trailing)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    // more content
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Label("Bench Press", systemImage: "dumbbell.fill").font(.system(size: 12, weight: .semibold, design: .rounded)).foregroundColor(.pink)
                            Spacer()
                            Text("2 sets remaining").font(.system(size: 12, weight: .regular, design: .rounded)).foregroundColor(Color(UIColor.systemGray))
                        }
                        ProgressView("", value: 50, total: 100)
                    }
                    .progressViewStyle(RoundedRectProgressViewStyle())
                    .activitySystemActionForegroundColor(Color.black)
                    .padding(.horizontal)
                }
            } compactLeading: {
                Image(systemName: "dumbbell.fill")
                    .font(Font.system(.subheadline).bold()).foregroundColor(.pink)
                    .padding(.leading, 2)
                    .shadow(color: .pink, radius: 3)
            } compactTrailing: {
                Text("🔥")
            } minimal: {
                Text("🔥")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

struct WidgetExtensionLiveActivity_Previews: PreviewProvider {
    static let attributes = TimerAttributes()
    static let contentState = TimerAttributes.TimerStatus(startTime: .now)

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
