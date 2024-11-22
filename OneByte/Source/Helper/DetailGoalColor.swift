//
//  DetailGoalColor.swift
//  OneByte
//
//  Created by 트루디 on 11/22/24.
//

import SwiftUI

enum DetailGoalColor: String {
    case color1 = "Color1"
    case color2 = "Color2"
    case color3 = "Color3"
    case color4 = "Color4"
    case color5 = "Color5"
    case color6 = "Color6"
    case color7 = "Color7"
    
    static func color(for achieveCount: Int) -> Color {
        switch achieveCount {
        case 1: return Color("Color1") // Custom Color1
        case 2: return Color("Color2") // Custom Color2
        case 3: return Color("Color3") // Custom Color3
        case 4: return Color("Color4") // Custom Color4
        case 5: return Color("Color5") // Custom Color5
        case 6: return Color("Color6") // Custom Color6
        case 7: return Color("Color7") // Custom Color7
        default: return Color.gray // 기본값 (예: 값이 없거나 범위를 벗어난 경우)
        }
    }
}
