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
    let calendar = Calendar(identifier: .iso8601)
    
    let monthInfoViewHeadPhraseDict: [String: String] = [
        "cloverX": "지난주에는 루틴에 신경을 못쓰셨나봐요",
        "green": "지난주에는 초록 클로버를 받았어요",
        "gold": "지난주에는 모든 루틴을 완수했어요",
        "firstTime": "지난주의 성취에 따라 응원해줄게요!"
    ]
    
    let monthInfoViewBodyPhraseDict : [String: [String]] = [
        "cloverX": ["괜찮아요. 항상 완벽할 필요는 없어요\n이번 주부터 다시 시작해봐요!",
                     "루틴은 꾸준함이 핵심이지만,\n쉬어가는 것도 과정의 일부예요. 다시 해볼까요?",
                     "꾸준함은 넘어지면서 배우는 거예요\n이번 주는 더 나아질 거니까 걱정 말아요"],
        "green": ["이미 충분히 잘하고 있어요!\n조금 더 스스로를 믿고, 조금 더 나아가 봐요",
                  "지금도 충분히 잘하고 있어요!\n조금만 있으면 큰 변화를 느낄 수 있을 거예요",
                  "모든 큰 성취는 작은 성취로 부터 시작해요\n이번주도 성취로 가득하게 채워봐요!"],
        "gold": ["지금 완벽하게 해내고 있어요!\n이 기세라면 뭐든 할 수 있을거에요",
                 "이번주도 차근차근 루틴을 완수해봐요\n지금처럼 꾸준히하면 곧 목표를 이룰 수 있을 거에요!",
                 "조금만 더 힘낸다면 이번주도 황금 클로버를\n수집할 수 있어요!"],
        "firstTime": ["아직 앱을 설치하고 한 주가 지나지 않았어요\n루틴을 실천해서 성취감을 느껴봐요!"]
    ]
    
    var installYear: Int? {
        UserDefaults.loadInstallYear()
    }
    
    var installMonth: Int? {
        UserDefaults.loadInstallMonth()
    }
    var installWeekOfYear: Int? {
        UserDefaults.loadInstallWeekOfYear()
    }
    
    var currentMonth: Int {
        if let data = UserDefaults.calendarData.first(where: { $0.0 == currentYear && $0.3 == currentWeekOfYear }) {
            return data.1 
        }
        return calendar.component(.month, from: Date())
    }
    
    var currentYear: Int {
        return calendar.component(.year, from: Date())
    }
    
    var currentWeekOfYear: Int {
        return calendar.component(.weekOfYear, from: Date())
    }
    
    var currentWeekOfMonth: Int {
        if let data = UserDefaults.calendarData.first(where: { $0.0 == currentYear && $0.3 == currentWeekOfYear }) {
            return data.2
        }
        return calendar.component(.weekOfMonth, from: Date())
    }
    
    var lastWeekClover: [Clover] {
        currentYearClovers.filter {$0.cloverWeekOfYear == currentWeekOfYear - 1}
    }
    
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
        let range = currentYearCloverMonthRange
        if range.max - range.min > 2 {
            let monthCount = currentMonth - range.min + 1
            return CGFloat(monthCount) * 73 + 174
        } else {
            return 388
        }
    }
    
    var currentYearCloverMonthRange: (min: Int, max: Int) {
        var minMonth: Int
        var maxMonth: Int

        if currentYear == installYear {
            minMonth = installMonth ?? 0
            maxMonth = currentMonth
            
            return (min: minMonth, max: maxMonth)
        } else {
            minMonth = 1
            maxMonth = currentMonth

            return (min: minMonth, max: maxMonth)
        }
    }
    
    func getMonthInfoViewPhrase() -> [String] {
        var state = ""
        var phrase: [String] = []
        var index: Int
        
        if installYear == currentYear && installWeekOfYear == currentWeekOfYear {
            state = "firstTime"
            index = 0
        }
        else {
            index = mapNumberFromZeroToTwo(num: currentWeekOfYear - 1)
            switch lastWeekClover.first?.cloverState {
            case 0:
                state = "cloverX"
            case 1:
                state = "green"
            case 2:
                state = "gold"
            default:
                state = "cloverX"
            }
        }
        phrase.append(monthInfoViewHeadPhraseDict[state]!)
        phrase.append(monthInfoViewBodyPhraseDict[state]![index])
        
        return phrase
    }
    
    func mapNumberFromZeroToTwo(num: Int) -> Int {
        let remainder = num % 3
        
        return remainder
        
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
        var emptyCloverCount = 0
        var greenCloverCount = 0
        var goldCloverCount = 0
        
        for clover in clovers {
            switch clover.cloverState {
            case 0:
                emptyCloverCount += 1
            case 1:
                greenCloverCount += 1
            case 2:
                goldCloverCount += 1
            default:
                break
            }
        }
        
        return [emptyCloverCount, greenCloverCount, goldCloverCount]
        
    }
   
}
