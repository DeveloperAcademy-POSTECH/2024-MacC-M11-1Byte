//
//  MyPageViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/14/24.
//

import SwiftUI
import SwiftData

@Observable
class StatisticViewModel {

    //    @Query(
    //        filter: #Predicate<Clover> { $0.cloverYear == Calendar.current.component(.year, from: Date()) }
    //    ) private var clovers: [Clover]
    var clovers: [Clover] = [] // 테스트 용
    
    @Query private var member: [Member]
    
    private let currentMonth = Calendar.current.component(.month, from: Date())

    func getCurrentMonthClovers() -> [Clover] {
        return filterCloversByMonth(month: currentMonth)
    }
    
    func getCurrentMonthCloverStates() -> [Int] {
        classifyCloverState(clovers: getCurrentMonthClovers())
    }
    
    func getCurrentYearCloverStates() -> [Int] {
        classifyCloverState(clovers: clovers)
    }
    
    func filterCloversByMonth(month: Int) -> [Clover] {
        return clovers.filter { clover in
            clover.cloverMonth == month
        }
    }

    func classifyCloverState(clovers: [Clover]) -> [Int] {
        var transparentCloverCount = 0
        var normalCloverCount = 0
        var goldenClovercount = 0
        
        for clover in clovers {
            switch clover.cloverState {
            case 0:
                transparentCloverCount += 1
            case 1:
                normalCloverCount += 1
            case 2:
                goldenClovercount += 1
            default:
                break
            }
        }
        
        return [transparentCloverCount, normalCloverCount, goldenClovercount]
        
    }
   
}
