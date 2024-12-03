//
//  MandalartMessageView.swift
//  OneByte
//
//  Created by 트루디 on 12/3/24.
//

import SwiftUI

struct MandalartMessageView: View {
    
    let message: String
    
    var body: some View {
        Text(message)
            .font(.Pretendard.Medium.size14)
            .foregroundStyle(.my3C3C3C)
            .multilineTextAlignment(.leading)
            .frame(height: 55)
            .padding(.horizontal)
            .background(.myEAEDE1)
            .clipShape(RoundedRectangle(cornerRadius: 50.0, style: .continuous))
            .overlay(alignment: .bottomLeading) {
                Image(systemName: "arrowtriangle.down.fill")
                    .font(.title)
                    .rotationEffect(.degrees(45))
                    .offset(x: -7, y: 11)
                    .foregroundStyle(.myEAEDE1)
            }
    }
}

#Preview {
    MandalartMessageView(message: "느리더라도 멈추지 않는다면\n결국 원하는 곳에 도달하게 돼요.")
}
