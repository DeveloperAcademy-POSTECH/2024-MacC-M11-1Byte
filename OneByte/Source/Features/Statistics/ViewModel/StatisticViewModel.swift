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
    
    /*
     올해 받은 클로버 중 이번 달에 받은 클로버만 필터링하는 함수
     리턴: 이번 달에 받은 클로버 리스트
     */
    func filterThisMonthClovers() -> [Clover] {
        let currentMonth = Calendar.current.component(.month, from: Date())
        return clovers.filter { clover in
            clover.cloverMonth == currentMonth
        }
    }
    
    /*
     가져온 클로버가 황금인지 아닌지 구별하는 함수
     리턴: 리스트; 인덱스 0번은 투명 클로버 개수, 1번은 일반, 2번은 황금
     */
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
