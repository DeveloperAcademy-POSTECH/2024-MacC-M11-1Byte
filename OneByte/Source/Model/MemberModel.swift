//
//  MemberModel.swift
//  OneByte
//
//  Created by 트루디 on 10/30/24.
//

import SwiftUI
import SwiftData

@Model
class MemberInfo {
    @Attribute(.unique) var id: UUID
    var name: String
    var appleUserId: String
    var appleRefreshToken: String
    var role: String
    
    init(id: UUID, name: String, appleUserId: String, appleRefreshToken: String, role: String) {
        self.id = id
        self.name = name
        self.appleUserId = appleUserId
        self.appleRefreshToken = appleRefreshToken
        self.role = role
    }
}
