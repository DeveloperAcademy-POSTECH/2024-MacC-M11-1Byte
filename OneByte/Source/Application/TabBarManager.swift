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
            TaskView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("할 일")
                }
            
            ObjectiveView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis.ascending.badge.clock")
                    Text("목표")
                }
            
            MyPageView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("마이페이지")
                }
        }
    }
}
