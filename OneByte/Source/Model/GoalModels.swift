//
//  MainGoal.swift
//  OneByte
//
//  Created by 이상도 on 10/29/24.
//

import SwiftUI
import SwiftData

@Model
class MainGoal {
    @Attribute(.primaryKey)
    var id: UUID
    var title: String
    var description: String
    
    init(id: UUID = UUID(), title: String, description: String) {
        self.id = id
        self.title = title
        self.description = description
    }
}
