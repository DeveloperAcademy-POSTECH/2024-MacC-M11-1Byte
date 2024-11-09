//
//  OnboardingProgressBar.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

struct OnboardingProgressBar: View {
    
    var value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                    .frame(height: 5)
                
                Rectangle()
                    .frame(width: min(CGFloat(value) * geometry.size.width, geometry.size.width),
                           height: geometry.size.height)
                    .foregroundColor(Color(hex: "636363"))
                    .animation(.linear, value: value)
                    .frame(height: 5)
            }
            .cornerRadius(5)
        }
    }
}

#Preview {
    OnboardingProgressBar(value: 0.5)
}
