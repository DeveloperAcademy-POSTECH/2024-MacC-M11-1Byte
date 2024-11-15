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
                .font(.Pretendard.SemiBold.size16)
            Spacer()
        }
        .padding()
        
    }
}

#Preview {
    NotificationRow()
}
