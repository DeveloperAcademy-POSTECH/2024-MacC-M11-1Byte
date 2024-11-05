//
//  TabBarView.swift
//  OneByte
//
//  Created by 트루디 on 10/17/24.
//

import SwiftUI

struct TabBarManager: View {
    let createService = ClientCreateService()
//    let updateService = ClientUpdateService(mainGoals: [], subGoals: [], detailGoals: [])
    let viewModel = CUTestViewModel(createService: ClientCreateService())
    
    var body: some View {
        TabView {
            MandalartView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("홈")
                }
            
            ReflectionView()
                .tabItem {
                    Image(systemName: "chart.bar.xaxis.ascending.badge.clock")
                    Text("회고")
                }
            
            MyPageView()
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
