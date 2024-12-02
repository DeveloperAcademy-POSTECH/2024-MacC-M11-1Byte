//
//  CustomTextModifier.swift
//  OneByte
//
//  Created by 이상도 on 12/1/24.
//

import SwiftUI

// 온보딩 메인 타이틀 모디파이어
struct CustomMainTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.Pretendard.Bold.size26)
            .multilineTextAlignment(.center)
            .lineSpacing(3.6)
            .kerning(0.4)
    }
}

// 온보딩 서브 타이틀 모디파이어
struct CustomSubTitle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.Pretendard.Regular.size16)
            .foregroundStyle(.my5A5A5A)
            .multilineTextAlignment(.center)
            .lineSpacing(2.4)
            .kerning(0.4)
    }
}

extension View {
    func customMainStyle() -> some View {
        modifier(CustomMainTitle())
    }
    func customSubStyle() -> some View {
        modifier(CustomSubTitle())
    }
}
