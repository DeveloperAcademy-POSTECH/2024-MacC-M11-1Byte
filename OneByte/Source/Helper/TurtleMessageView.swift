//
//  TurtleMessageView.swift
//  OneByte
//
//  Created by 이상도 on 11/20/24.
//

import SwiftUI

struct TurtleMessageView: View {
    
    let message: String
    
    var body: some View {
        Text(message)
            .font(.setPretendard(weight: .medium, size: 14))
            .foregroundStyle(.my3C3C3C)
            .multilineTextAlignment(.leading)
            .frame(height: 55)
            .kerning(0.24)
            .padding(.horizontal, 20)
            .background(.myD4E5CC)
            .clipShape(RoundedRectangle(cornerRadius: 50.0, style: .continuous))
            .overlay(alignment: .bottomTrailing) {
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.title)
                    .rotationEffect(.degrees(-45))
                    .offset(x: 5, y: 10)
                    .foregroundStyle(.myD4E5CC)
            }
    }
}

#Preview {
    TurtleMessageView(message: "느리더라도 멈추지 않는다면\n결국 원하는 곳에 도달하게 돼요.")
}
