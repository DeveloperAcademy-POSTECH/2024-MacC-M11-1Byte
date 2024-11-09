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
                
                Rectangle()
                    .frame(width: min(CGFloat(value) * geometry.size.width, geometry.size.width),
                           height: geometry.size.height)
                    .foregroundColor(.blue)
                    .animation(.linear, value: value)
            }
            .cornerRadius(5)
        }
    }
}

#Preview {
    OnboardingProgressBar(value: 0.5)
}
