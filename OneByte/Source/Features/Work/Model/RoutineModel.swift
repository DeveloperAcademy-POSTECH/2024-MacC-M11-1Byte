//
//  RoutineModel.swift
//  OneByte
//
//  Created by 이상도 on 11/19/24.
//

import Foundation

// MARK: 루틴 탭 상위 Tab
enum routineTapInfo : String, CaseIterable {
    case today = "오늘의 루틴"
    case all = "전체 루틴"
}

// MARK: 루틴 탭/전체 루틴 Tab
enum tapInfo : String, CaseIterable {
    
    case all, first, second, third, fourth
    
    var colorClover: String {
        switch self {
        case .all:
            return "ColorCloverAll"
        case .first:
            return "ColorClover1"
        case .second:
            return "ColorClover2"
        case .third:
            return "ColorClover3"
        case .fourth:
            return "ColorClover4"
        }
    }
    
    var grayClover: String {
        switch self {
        case.all:
            return "GrayCloverAll"
        case .first:
            return "GrayClover1"
        case .second:
            return "GrayClover2"
        case .third:
            return "GrayClover3"
        case .fourth:
            return "GrayClover4"
        }
    }
}
