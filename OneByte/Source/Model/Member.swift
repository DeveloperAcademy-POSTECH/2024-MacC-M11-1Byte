//
//  Member.swift
//  OneByte
//
//  Created by Dabin Lee on 11/20/24.
//

import SwiftData
import SwiftUI

@Model
class Member {
    var id: Int
    var nickName: String
    
    init(id: Int, nickName: String) {
        self.id = id
        self.nickName = nickName
    }
}
