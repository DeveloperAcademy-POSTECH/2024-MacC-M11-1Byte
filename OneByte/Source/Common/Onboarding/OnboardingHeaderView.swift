//
//  OnboardingHeaderView.swift
//  OneByte
//
//  Created by 이상도 on 11/30/24.
//

import SwiftUI

// MARK: 온보딩 상단 BackButton + ProgessBar
struct OnboardingHeaderView: View {
    
    let progressValue: Double
    let onBack: () -> Void
    
    var body: some View {
        HStack(spacing: 14) {
            Button {
                onBack()
            } label: {
                HStack {
                    Image(systemName: "chevron.left")
                        .frame(width: 24, height: 24)
                        .tint(.black)
                        .padding(.leading, 4)
                }
            }
            OnboardingProgressBar(value: progressValue)
                .frame(height: 10)
                .padding(.trailing, 43)
        }
    }
}
