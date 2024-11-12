//
//  MadalartShape.swift
//  OneByte
//
//  Created by 트루디 on 11/12/24.
//

import SwiftUI

// 특정 모서리에만 코너 라디우스를 줄 수 있는 커스텀 View Modifier
struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        self.modifier(CornerRadiusStyle(radius: radius, corners: corners))
    }
}

// 특정 모서리만 둥글게 처리하는 커스텀 Shape
struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
// 특정 인덱스에 맞는 모서리 스타일을 반환하는 함수
func cornerStyle(for index: Int) -> UIRectCorner {
    switch index {
    case 0: return .topLeft
    case 2: return .topRight
    case 6: return .bottomLeft
    case 8: return .bottomRight
    default: return []
    }
}
