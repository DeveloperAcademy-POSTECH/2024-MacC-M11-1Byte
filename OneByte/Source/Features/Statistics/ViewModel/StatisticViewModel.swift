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
    
    var clovers: [Clover] = []
    var profile: [Profile] = []
    
    let currentMonth = Calendar.current.component(.month, from: Date())
    let currentYear = Calendar.current.component(.year, from: Date())
    
    var currentMonthClovers: [Clover] {
        filterCloversByMonth(clovers: currentYearClovers, month: currentMonth)
            .filter { $0.cloverState > 1 }
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
            return CGFloat(monthCount) * 62 + 48
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
        profile.first?.nickName ?? "다라"
    }
    
    func setClovers(_ newClovers: [Clover]) {
        
        self.clovers =  newClovers
    }
    
    func setProfile(_ newProfile: [Profile]) {
       
        self.profile = newProfile
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
