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
//            .font(.Pretendard.Medium.size12)
            .frame(width: 78/393 * UIScreen.main.bounds.width, height: 78/852 * UIScreen.main.bounds.height)
            .background(color)
            .foregroundStyle(.black)
            .cornerRadius(8)
    }
}
struct NextMandalartButtonModifier: ViewModifier {
    var color: Color

    func body(content: Content) -> some View {
        content
//            .font(.Pretendard.Medium.size18)
            .frame(width: 123/393 * UIScreen.main.bounds.width, height: 123/852 * UIScreen.main.bounds.height)
            .background(color)
            .foregroundStyle(.black)
            .cornerRadius(8)
    }
}

