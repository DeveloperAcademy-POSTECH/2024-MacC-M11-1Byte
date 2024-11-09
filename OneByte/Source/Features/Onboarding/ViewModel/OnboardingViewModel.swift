//
//  OnboardingViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI
import SwiftData


class OnboardingViewModel: ObservableObject {
    
    private let createService: CreateGoalUseCase
    private let updateService: UpdateGoalUseCase
    
    init(createService: CreateGoalUseCase, updateService: UpdateGoalUseCase ) {
        self.createService = createService
        self.updateService = updateService
    }
    
    func createGoals(modelContext: ModelContext) {
        createService.createGoals(modelContext: modelContext)
    }

}
