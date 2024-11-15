//
//  Profile.swift
//  OneByte
//
//  Created by 이상도 on 11/14/24.
//

import SwiftData
import SwiftUI

@Model
class Profile {
    var nickName: String
    
    init(nickName: String) {
        self.nickName = nickName
    }
}
