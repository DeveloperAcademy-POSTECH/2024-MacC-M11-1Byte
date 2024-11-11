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
            .font(.system(size: 7))
            .frame(width: 30, height: 30)
            .background(color)
            .foregroundStyle(.white)
            .cornerRadius(8)
    }
}
struct NextMandalartButtonModifier: ViewModifier {
    var color: Color
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14))
            .frame(width: 115, height: 115)
            .background(color)
            .foregroundStyle(.white)
            .cornerRadius(8)
    }
}
