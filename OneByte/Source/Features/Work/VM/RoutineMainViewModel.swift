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
    
    init(routineType: routineTapInfo) {
        self.routineType = routineType
    }
    
    func routinePicker(to picker: routineTapInfo) {
        withAnimation(.easeInOut) {
            self.selectedPicker = picker
        }
    }
}
