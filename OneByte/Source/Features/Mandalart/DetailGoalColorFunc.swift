//
//  DetailGoalColorFunc.swift
//  OneByte
//
//  Created by 트루디 on 11/23/24.
//

import SwiftUI

func colorForGoal(achieveGoal: Int, achieveCount: Int) -> Color {
    switch (achieveGoal, achieveCount) {
    case(0,0):
        return Color.myD6F3D4
    case (1, 0):
        return Color.myD6F3D4
    case (1, 1):
        return Color.my438243
    case (2, 1...2):
        return achieveCount == 1 ? Color.myBFEBBB : Color.my428142
    case (3, 1...3):
        switch achieveCount {
        case 1: return Color.myBFEBBB
        case 2: return Color.my85C985
        default: return Color.my428142
        }
    case (4, 1...4):
        switch achieveCount {
        case 1: return Color.myBFEBBB
        case 2: return Color.myA0D8A0
        case 3: return Color.my6CB76C
        default: return Color.my428142
        }
    case (5, 1...5):
        switch achieveCount {
        case 1: return Color.myBFEBBB
        case 2: return Color.myA0D8A0
        case 3: return Color.my78C478
        case 4: return Color.my599859
        default: return Color.my428142
        }
    case (6, 1...6):
        switch achieveCount {
        case 1: return Color.myBFEBBB
        case 2: return Color.myA8DCAB
        case 3: return Color.my86CD86
        case 4: return Color.my6FB56F
        case 5: return Color.my599859
        default: return Color.my428142
        }
    case (7, 1...7):
        switch achieveCount {
        case 1: return Color.myBFEBBB
        case 2: return Color.myB0E4B0
        case 3: return Color.my95D895
        case 4: return Color.my7FC77F
        case 5: return Color.my6FB56F
        case 6: return Color.my599859
        default: return Color.my428142
        }
    default:
        return Color.myD6F3D4 // 기본 색상
    }
}
