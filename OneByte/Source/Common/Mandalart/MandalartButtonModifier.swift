//
//  MandalartButton.swift
//  OneByte
//
//  Created by 트루디 on 11/6/24.
//

import SwiftUI
struct MandalartButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 78/393 * UIScreen.main.bounds.width, height: 78/852 * UIScreen.main.bounds.height)
            .foregroundStyle(.black)
            .cornerRadius(8)
    }
}
