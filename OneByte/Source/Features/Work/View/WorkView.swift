//
//  WorkView.swift
//  OneByte
//
//  Created by 트루디 on 10/17/24.
//

import SwiftUI

struct WorkView: View {

    var body: some View {
        VStack {
            HStack {
                Text("할 일")
                    .font(.Pretendard.Bold.size22)
                    .foregroundStyle(Color(hex: "B4A99D"))
                
                Spacer()
                
                NavigationLink {
                    SettingView()
                } label: {
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color(hex: "B4A99D"))
                }
            }
            .padding()
            Spacer()
        }
    }
}

#Preview {
    WorkView()
}
