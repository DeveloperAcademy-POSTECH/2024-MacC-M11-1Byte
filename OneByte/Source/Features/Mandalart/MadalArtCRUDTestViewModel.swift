//
//  MadalArtCRUDTestViewModel.swift
//  OneByte
//
//  Created by 트루디 on 10/30/24.
//

import SwiftUI
import SwiftData

class CUTestViewModel: ObservableObject {
    private let createService: CreateGoalUseCase

    init(createService: CreateGoalUseCase) {
        self.createService = createService
    }
    
    func saveGoalsFromJSON(jsonString: String, modelContext: ModelContext) {
        // JSON 문자열을 Data로 변환
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Error converting JSON string to Data")
            return
        }
        
        // JSON을 [String: Any] 형식으로 변환
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any]
            
            // jsonObject가 nil이 아닐 경우에만 saveGoalsFromJSON 호출
            if let json = jsonObject {
                createService.saveGoalsFromJSON(json: json, modelContext: modelContext)
            } else {
                print("Error: JSON parsing resulted in nil")
            }
        } catch {
            print("Error parsing JSON: \(error)")
        }
    }
}
