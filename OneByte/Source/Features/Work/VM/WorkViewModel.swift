//
//  WorkViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/19/24.
//

import SwiftUI

@Observable
class WorkViewModel {
    
    var selectedPicker: routineTapInfo = .today
    var routineType: routineTapInfo
    
    init(routineType: routineTapInfo) {
        self.routineType = routineType
    }
    
    func updatePicker(to picker: routineTapInfo) {
        withAnimation(.easeInOut) {
            self.selectedPicker = picker
        }
    }
}
