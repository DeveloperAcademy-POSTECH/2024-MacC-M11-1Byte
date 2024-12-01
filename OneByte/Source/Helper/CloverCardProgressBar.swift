//
//  CloverCardProgressBar.swift
//  OneByte
//
//  Created by 이상도 on 11/29/24.
//

import SwiftUI

// MARK: 클로버카드에 사용되는 Progress
struct CloverCardProgressBar: View {
    
    var value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundStyle(.white)
                    .frame(height: 7)
                
                Rectangle()
                    .frame(width: min(CGFloat(value) * geometry.size.width, geometry.size.width),
                           height: geometry.size.height)
                    .foregroundStyle(.myFFA64A)
                    .animation(.linear, value: value)
                    .frame(height: 7)
            }
            .cornerRadius(5)
        }
    }
}

#Preview {
    CloverCardProgressBar(value: 0.5)
}
