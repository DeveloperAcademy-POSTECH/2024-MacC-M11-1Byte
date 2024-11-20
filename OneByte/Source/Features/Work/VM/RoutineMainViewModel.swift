//
//  WorkViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/19/24.
//

import SwiftUI

@Observable
class RoutineMainViewModel {
    
    var mainDateManager = DateManager()
    var selectedPicker: routineTapInfo = .today
    var routineType: routineTapInfo
    var todayDate = Date() // 헤더뷰
    
    var message = "느리더라도 멈추지 않는다면\n결국 원하는 곳에 도달하게 돼요."
    
    init(routineType: routineTapInfo) {
        self.routineType = routineType
    }
    
    func routinePicker(to picker: routineTapInfo) {
        withAnimation(.easeInOut) {
            self.selectedPicker = picker
        }
    }
}
