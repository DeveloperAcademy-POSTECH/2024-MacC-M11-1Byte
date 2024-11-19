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
    var cloverMonth: Int
    var cloverWeekOfMonth: Int
    var cloverWeekOfYear: Int
    var cloverState: Int
    
    init(id: Int, cloverYear: Int, cloverMonth: Int, cloverWeekOfMonth: Int, cloverWeekOfYear: Int, cloverState: Int) {
        self.id = id
        self.cloverYear = cloverYear
        self.cloverMonth = cloverMonth
        self.cloverWeekOfMonth = cloverWeekOfMonth
        self.cloverWeekOfYear = cloverWeekOfYear
        self.cloverState = cloverState
    }
}
