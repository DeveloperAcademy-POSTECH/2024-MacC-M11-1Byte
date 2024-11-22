//
//  MyPageViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/14/24.
//

import SwiftUI
import SwiftData

class StatisticViewModel: ObservableObject  {
    
    @Query var profile: [Profile]
    @Query var clovers: [Clover]
    
//    var profile: [Profile] = [Profile(nickName: "이빈치")]
//    var clovers: [Clover] = [
//        Clover(id: 1, cloverYear: 2024, cloverMonth: 11, cloverWeekOfMonth: 1, cloverWeekOfYear: 45, cloverState: 2),
//        Clover(id: 2, cloverYear: 2024, cloverMonth: 11, cloverWeekOfMonth: 2, cloverWeekOfYear: 46, cloverState: 1),
//        Clover(id: 3, cloverYear: 2024, cloverMonth: 11, cloverWeekOfMonth: 3, cloverWeekOfYear: 47, cloverState: 0),
//        Clover(id: 4, cloverYear: 2024, cloverMonth: 11, cloverWeekOfMonth: 4, cloverWeekOfYear: 48, cloverState: 0),
//        Clover(id: 5, cloverYear: 2024, cloverMonth: 12, cloverWeekOfMonth: 1, cloverWeekOfYear: 49, cloverState: 0),
//        Clover(id: 6, cloverYear: 2024, cloverMonth: 12, cloverWeekOfMonth: 2, cloverWeekOfYear: 50, cloverState: 0),
//        Clover(id: 7, cloverYear: 2024, cloverMonth: 12, cloverWeekOfMonth: 3, cloverWeekOfYear: 51, cloverState: 0),
//        Clover(id: 7, cloverYear: 2024, cloverMonth: 12, cloverWeekOfMonth: 4, cloverWeekOfYear: 52, cloverState: 0),
//        Clover(id: 8, cloverYear: 2024, cloverMonth: 10, cloverWeekOfMonth: 1, cloverWeekOfYear: 41, cloverState: 2),
//        Clover(id: 8, cloverYear: 2024, cloverMonth: 10, cloverWeekOfMonth: 2, cloverWeekOfYear: 42, cloverState: 1),
//        Clover(id: 8, cloverYear: 2024, cloverMonth: 10, cloverWeekOfMonth: 3, cloverWeekOfYear: 43, cloverState: 3),
//        Clover(id: 8, cloverYear: 2024, cloverMonth: 10, cloverWeekOfMonth: 4, cloverWeekOfYear: 44, cloverState: 2),
//        Clover(id: 8, cloverYear: 2024, cloverMonth: 9, cloverWeekOfMonth: 1, cloverWeekOfYear: 36, cloverState: 0),
//        Clover(id: 8, cloverYear: 2024, cloverMonth: 9, cloverWeekOfMonth: 2, cloverWeekOfYear: 37, cloverState: 1),
//        Clover(id: 8, cloverYear: 2024, cloverMonth: 9, cloverWeekOfMonth: 3, cloverWeekOfYear: 38, cloverState: 3),
//        Clover(id: 8, cloverYear: 2024, cloverMonth: 9, cloverWeekOfMonth: 4, cloverWeekOfYear: 39, cloverState: 3),
//        Clover(id: 8, cloverYear: 2024, cloverMonth: 9, cloverWeekOfMonth: 5, cloverWeekOfYear: 40, cloverState: 2),
//        
//    ] // 테스트 데이터

    
    let currentMonth = Calendar.current.component(.month, from: Date())
    let currentYear = Calendar.current.component(.year, from: Date())
    
    var currentMonthClovers: [Clover] {
        filterCloversByMonth(clovers: clovers, month: currentMonth)
    }
    
    var currentYearClovers: [Clover] {
        filterCloversByYear(clovers: clovers, year: currentYear)
    }
    
    var currentMonthCloverStates: [Int] {
        classifyCloverState(clovers: currentMonthClovers)
    }
    
    var currentYearCloverStates: [Int] {
        classifyCloverState(clovers: currentYearClovers)
    }
    
    var weeklyCloverInfoHeight: CGFloat {
        if let range = currentYearCloverMonthRange {
            let monthCount = currentMonth - range.min + 1
            return CGFloat(monthCount) * 65 + 40
        } else {
            return 44
        }
    }
    
    var currentYearCloverMonthRange: (min: Int, max: Int)? {
        let months = currentYearClovers.map { $0.cloverMonth }
        guard let minMonth = months.min(), let maxMonth = months.max() else {
            return nil
        }
        return (min: minMonth, max: maxMonth)
    }
    
    var profileNickName: String {
        "이빈치" // 현재 프로필 데이터 없어서 빌드 안 되기 때문에 하드코딩 해놓음 -> profile[0].nickName
    }
    
    func filterCloversByMonth(clovers: [Clover], month: Int) -> [Clover] {
        return clovers.filter { $0.cloverMonth == month }
    }
    
    func filterCloversByYear(clovers: [Clover], year: Int) -> [Clover] {
        return clovers.filter { $0.cloverYear == year }
    }
    
    func classifyCloverState(clovers: [Clover]) -> [Int] {
        var lightCloverCount = 0
        var greenCloverCount = 0
        var goldCloverCount = 0
        
        for clover in clovers {
            switch clover.cloverState {
            case 1:
                lightCloverCount += 1
            case 2:
                greenCloverCount += 1
            case 3:
                goldCloverCount += 1
            default:
                break
            }
        }
        
        return [lightCloverCount, greenCloverCount, goldCloverCount]
        
    }
   
}
