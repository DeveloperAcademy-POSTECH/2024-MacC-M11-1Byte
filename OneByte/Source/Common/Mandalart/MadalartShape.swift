//
//  MadalartShape.swift
//  OneByte
//
//  Created by 트루디 on 11/12/24.
//

import SwiftUI

// 특정 모서리에만 코너 반경을 주는 커스텀 View Modifier
struct CornerRadiusStyle: ViewModifier {
    var radius: CGFloat
    var corners: UIRectCorner
    var defaultRadius: CGFloat  // 기본 코너 반경 설정
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: defaultRadius) // 기본 코너 반경 사용
                    .foregroundColor(.clear)
            )
            .clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner, defaultRadius: CGFloat) -> some View {
        self.modifier(CornerRadiusStyle(radius: radius, corners: corners, defaultRadius: defaultRadius))
    }
}

// 특정 모서리만 둥글게 처리하는 커스텀 Shape
struct RoundedCorner: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// 특정 인덱스에 맞는 모서리 스타일을 반환하는 함수
func cornerStyle(for index: Int) -> UIRectCorner {
    switch index {
    case 0: return .topLeft
    case 1: return .topRight
    case 2: return .bottomLeft
    case 3: return .bottomRight
    default: return []
    }
}
