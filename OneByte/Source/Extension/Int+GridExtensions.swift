//
//  Int+GridExtensions.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

// MARK: 온보딩 3x3뷰에서의 cornerRadius 부분적용
extension Int {
    func cornerRadiusValues(for3x3Grid defaultRadius: CGFloat = 20) -> (topLeft: CGFloat, topRight: CGFloat, bottomLeft: CGFloat, bottomRight: CGFloat) {
        switch self {
        case 1:
            return (topLeft: defaultRadius, topRight: 0, bottomLeft: 0, bottomRight: 0) // 왼쪽 위 모서리만
        case 3:
            return (topLeft: 0, topRight: defaultRadius, bottomLeft: 0, bottomRight: 0) // 오른쪽 위 모서리만
        case 7:
            return (topLeft: 0, topRight: 0, bottomLeft: defaultRadius, bottomRight: 0) // 왼쪽 아래 모서리만
        case 9:
            return (topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: defaultRadius) // 오른쪽 아래 모서리만
        case 5:
            return (topLeft: defaultRadius, topRight: defaultRadius, bottomLeft: defaultRadius, bottomRight: defaultRadius) // 중앙은 네 모서리 모두
        default:
            return (topLeft: 0, topRight: 0, bottomLeft: 0, bottomRight: 0) // 다른 셀들은 반경 없음
        }
    }
}
