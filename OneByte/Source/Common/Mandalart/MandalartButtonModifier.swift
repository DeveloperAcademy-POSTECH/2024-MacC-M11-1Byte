//
//  MandalartButton.swift
//  OneByte
//
//  Created by 트루디 on 11/6/24.
//

import SwiftUI
struct MandalartButtonModifier: ViewModifier {
    var color: Color
    func body(content: Content) -> some View {
        content
            .font(.Pretendard.Medium.size10)
            .frame(width: 40/393 * UIScreen.main.bounds.width, height: 40/393 * UIScreen.main.bounds.width)
            .background(color)
            .foregroundStyle(.black)
            .cornerRadius(8)
    }
}
struct NextMandalartButtonModifier: ViewModifier {
    var color: Color

    func body(content: Content) -> some View {
        content
            .font(.Pretendard.Medium.size16)
            .frame(width: 115/393 * UIScreen.main.bounds.width, height: 115/393 * UIScreen.main.bounds.width)
            .background(color)
            .foregroundStyle(.black)
            .cornerRadius(8)
    }
}

