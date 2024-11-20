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
    @Query private var clovers: [Clover]
    
    private let currentMonth = Calendar.current.component(.month, from: Date())
    private let currentYear = Calendar.current.component(.year, from: Date())
    
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
