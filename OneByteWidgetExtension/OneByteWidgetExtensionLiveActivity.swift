//
//  OneByteWidgetExtensionLiveActivity.swift
//  OneByteWidgetExtension
//
//  Created by 트루디 on 3/7/26.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct OneByteWidgetExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct OneByteWidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: OneByteWidgetExtensionAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension OneByteWidgetExtensionAttributes {
    fileprivate static var preview: OneByteWidgetExtensionAttributes {
        OneByteWidgetExtensionAttributes(name: "World")
    }
}

extension OneByteWidgetExtensionAttributes.ContentState {
    fileprivate static var smiley: OneByteWidgetExtensionAttributes.ContentState {
        OneByteWidgetExtensionAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: OneByteWidgetExtensionAttributes.ContentState {
         OneByteWidgetExtensionAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: OneByteWidgetExtensionAttributes.preview) {
   OneByteWidgetExtensionLiveActivity()
} contentStates: {
    OneByteWidgetExtensionAttributes.ContentState.smiley
    OneByteWidgetExtensionAttributes.ContentState.starEyes
}
