//
//  Date+.swift
//  OneByte
//
//  Created by 이상도 on 11/2/24.
//

import Foundation

extension Date {
    var YearString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년"
        return formatter.string(from: self)
    }
}
