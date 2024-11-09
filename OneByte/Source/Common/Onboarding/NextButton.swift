//
//  NextButton.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

// MARK: 온보딩에서 목표 입력 여부에 따라, 버튼 색상 & 활성화 여부 변경되는 공통 버튼
struct NextButton<Content: View>: View {
    
    let label: Content
    let action: () -> Void
    let isEnabled: Bool
    
    init(isEnabled: Bool, action: @escaping () -> Void, @ViewBuilder label: () -> Content) {
        self.isEnabled = isEnabled
        self.label = label()
        self.action = action
    }
    
    var body: some View {
        Button(action: {
            if isEnabled {
                action()
            }
        }) {
            label
                .font(.Pretendard.Regular.size18)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 53)
                .background(isEnabled ? Color(hex: "636363") : Color(hex: "C9C9C9"))
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .disabled(!isEnabled) // 버튼이 비활성화된 경우 터치가 불가능하게 설정
    }
}
