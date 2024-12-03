//
//  TabBarView.swift
//  OneByte
//
//  Created by 트루디 on 10/17/24.
//

import SwiftUI
import SwiftData

struct TabBarManager: View {
    
    @Environment(\.scenePhase) private var scenePhase // 앱 상태 감지 ( foreground <-> background )
    @Environment(\.modelContext) private var modelContext
    @Query private var mainGoals: [MainGoal]
    @AppStorage("FirstOnboarding") private var FirstOnboarding: Bool = true
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool = false
    @State private var isTabBarMainVisible: Bool = true
    @State private var selectedTab: Int = 0
    
    @State private var showCloverCardView: Bool = false  // 클로버 카드뷰 제어
    
    init() {
        // UITabBarAppearance로 탭바 경계선 제거
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.shadowImage = nil // 그림자 제거
        tabBarAppearance.shadowColor = .myB2AFAA
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
    }
    
    var body: some View {
        ZStack {
            if FirstOnboarding {
                OnboardingStartView()
            } else {
                TabView(selection: $selectedTab) {
                    RoutineMainView(isTabBarMainVisible: $isTabBarMainVisible)
                        .tabItem {
                            (selectedTab == 0 ? Image("Tab_Routine_Selected") : Image("Tab_Routine_Default"))
                            Text("루틴")
                        }
                        .tag(0)
                    
                    MandalartView(isTabBarMainVisible: $isTabBarMainVisible)
                        .tag(1)
                    
                    StatisticView(isTabBarMainVisible: $isTabBarMainVisible)
                        .tabItem {
                            (selectedTab == 2 ? Image("Tab_Myclover_Selected") : Image("Tab_Myclover_Default"))
                            Text("나의 클로버")
                        }
                        .tag(2)
                }
                .accentColor(.my6FB56F)
                .onChange(of: selectedTab) { oldValue, newValue in
                    triggerHaptic()
                }
                .onAppear {
                    // 온보딩 완료 여부에 따라 기본 탭 설정
                    if !hasSeenOnboarding {
                        isRoutineReset() // 온보딩 이후 첫 초기화 작업 한번만 실행 ( 앱 설치날짜를, 비교기준날짜로 담아둠 )
                        selectedTab = 1
                        hasSeenOnboarding = true
                    } else {
                        selectedTab = 0
                    }
                }
                
                if isTabBarMainVisible { // 중앙탭 버튼
                    VStack {
                        Spacer()
                        (selectedTab == 1 ? Image("Tab_Myplan_Selected") : Image("Tab_Myplan_Default"))
                            .padding(.bottom, 34)
                            .onTapGesture {
                                selectedTab = 1 // 중앙 버튼 선택 시 나의계획 뷰로 이동
                            }
                    }
                    .ignoresSafeArea()
                }
            }
        }
//        .onChange(of: scenePhase) { oldPhase, newPhase in
//            if newPhase == .active {
//                isRoutineReset() // 앱이 활성화될 때마다 실행
//            }
//        }
//        .fullScreenCover(isPresented: $showCloverCardView) {
//            CloverCardView(selectedTab: $selectedTab)
//        }
    }
    
    // 초기화를 해야하는 새로운 주차인지 판별 -> true면 CloverView 로딩
    private func isRoutineReset() {
        if !FirstOnboarding {
            let resetManager = WeeklyResetManager()
            if resetManager.needsReset() {
                showCloverCardView = true
            }
        }
    }
    
    // 햅틱
    private func triggerHaptic() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}


#Preview {
    TabBarManager()
}
