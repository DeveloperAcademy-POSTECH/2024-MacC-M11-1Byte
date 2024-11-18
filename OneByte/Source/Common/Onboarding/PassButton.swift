//
//  OnboardingShortButtonView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

// MARK: 온보딩에서 흰 배경색상의 공통 버튼 ( ex) SKIP버튼, 잘 모르겠어요 버튼 )
struct PassButton<Content: View>: View {
    
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
                .font(.Pretendard.Regular.size18)
                .foregroundStyle(Color.my636363)
                .frame(maxWidth: .infinity)
                .frame(height: 53)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.myACACAC, lineWidth: 1)
        )
    }
}
