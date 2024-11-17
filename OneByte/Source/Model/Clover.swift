//
//  Clover.swift
//  OneByte
//
//  Created by 이상도 on 11/17/24.
//

import Foundation
import SwiftData

@Model
class Clover {
    var id: Int
    var cloverYear: Int
    var cloverWeek: Int
    var cloverState: Int
    
    init(id: Int, cloverYear: Int, cloverWeek: Int, cloverState: Int) {
        self.id = id
        self.cloverYear = cloverYear
        self.cloverWeek = cloverWeek
        self.cloverState = cloverState
    }
}
