//
//  OnboardingWideButtonView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

// MARK: 온보딩에서 다음 화면으로 넘어가는 공통 버튼
struct GoButton<Content: View>: View {
    
    let label: Content
    let action: () -> Void
    
    init(action: @escaping () -> Void, @ViewBuilder label: () -> Content) {
        self.label = label()
        self.action = action
    }
    
    var body: some View {
        Button {
            action()
        } label: {
            label
                .font(.Pretendard.Medium.size18)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 53)
                .background(Color.my538F53)
                .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}
