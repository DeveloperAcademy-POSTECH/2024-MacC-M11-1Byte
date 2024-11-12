//
//  OnboardingProgressBar.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

// MARK: 온보딩화면에서 사용되는 Progress
struct OnboardingProgressBar: View {
    
    var value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundStyle(.gray)
                    .frame(height: 5)
                
                Rectangle()
                    .frame(width: min(CGFloat(value) * geometry.size.width, geometry.size.width),
                           height: geometry.size.height)
                    .foregroundStyle(Color(hex: "538F53"))
                    .animation(.linear, value: value)
                    .frame(height: 10)
            }
            .cornerRadius(5)
        }
    }
}

#Preview {
    OnboardingProgressBar(value: 0.5)
}
