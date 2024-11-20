//
//  MyPageViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/14/24.
//

import SwiftUI
import SwiftData

class StatisticViewModel: ObservableObject  {
    
    @Query private var profile: [Profile]
    @Query private var allClovers: [Clover]
    
    private let currentMonth = Calendar.current.component(.month, from: Date())
    private let currentYear = Calendar.current.component(.year, from: Date())
    
    private var clovers: [Clover] {
        allClovers.filter {$0.cloverYear == currentYear}
    }
    
    func getCurrentMonthClovers() -> [Clover] {
        return filterCloversByMonth(month: currentMonth)
    }
    
    func getCurrentMonthCloverStates() -> [Int] {
        classifyCloverState(clovers: getCurrentMonthClovers())
    }
    
    func getCurrentYearCloverStates() -> [Int] {
        classifyCloverState(clovers: clovers)
    }
    
    func getProfileNickName() -> String {
        return "이빈치" // profile[0].nickName
    }
    
    func filterCloversByMonth(month: Int) -> [Clover] {
        return clovers.filter { clover in
            clover.cloverMonth == month
        }
    }
    
    func classifyCloverState(clovers: [Clover]) -> [Int] {
        var transparentCloverCount = 0
        var normalCloverCount = 0
        var goldenCloverCount = 0
        
        for clover in clovers {
            switch clover.cloverState {
            case 0:
                transparentCloverCount += 1
            case 1:
                normalCloverCount += 1
            case 2:
                goldenCloverCount += 1
            default:
                break
            }
        }
        
        return [transparentCloverCount, normalCloverCount, goldenCloverCount]
        
    }
   
}
