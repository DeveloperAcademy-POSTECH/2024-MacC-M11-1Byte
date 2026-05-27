//
//  OneByteWidgetExtensionBundle.swift
//  OneByteWidgetExtension
//
//  Created by 트루디 on 3/7/26.
//

import WidgetKit
import SwiftUI

@main
struct OneByteWidgetExtensionBundle: WidgetBundle {
    var body: some Widget {
        OneByteTodayRoutineWidget()
        OneByteWidgetExtensionControl()
        OneByteWidgetExtensionLiveActivity()
    }
}
