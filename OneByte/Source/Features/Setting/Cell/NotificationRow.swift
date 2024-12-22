//
//  NotificationRow.swift
//  OneByte
//
//  Created by 이상도 on 11/15/24.
//

import SwiftUI

struct NotificationRow: View {
    
    var body: some View {
        HStack {
            Text("알림 설정")
                .font(.setPretendard(weight: .semiBold, size: 16))
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding()
        
    }
}

#Preview {
    NotificationRow()
}
