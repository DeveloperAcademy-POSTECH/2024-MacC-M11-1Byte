//
//  TabBarView.swift
//  OneByte
//
//  Created by 트루디 on 10/17/24.
//

import SwiftUI

struct TabBarManager: View {
    
    var body: some View {
        TabView {
            MandalartView()
                .tabItem {
                    Image(systemName: "star.fill")
                    Text("나의 목표")
                }
            
            RoutineMainView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle.fill")
                    Text("루틴")
                }
            
            StatisticView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("마이페이지")
                }
        }
    }
}

#Preview {
    TabBarManager()
}
