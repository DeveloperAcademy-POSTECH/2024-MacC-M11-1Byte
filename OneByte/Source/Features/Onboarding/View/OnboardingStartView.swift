//
//  OnboardingStartView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI
import SwiftData

struct OnboardingStartView: View {
    
    @Environment(\.modelContext) private var modelContext
    @State private var navigationManager = NavigationManager()
    
    @Query var clovers: [Clover]
    @State var viewModel = OnboardingViewModel(createService: CreateService(), updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []))
    
    @State private var nowOnboard: OnboardingExplain = .first
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack {
                // 만다라트 설명 5페이지뷰 탭뷰
                TabView(selection: $nowOnboard) {
                    ForEach(OnboardingExplain.allCases, id: \.self) { onboarding in
                        OnboardingExplainPageView(
                            nowOnboard: nowOnboard
                        )
                        .tag(onboarding)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Indicator ( 현재 Page/전체 Page 나타내는 dots )
                VStack {
                    HStack(spacing: 8) {
                        ForEach(OnboardingExplain.allCases, id: \.self) { onboarding in
                            Circle()
                                .frame(width: 8, height: 8)
                                .foregroundStyle(nowOnboard == onboarding ? Color.my636363 : Color.my919191)
                        }
                    }
                }
                .padding(.bottom)
                
                GoButton {
                    navigationManager.push(to: .onboardReady)
                } label: {
                    Text("다음")
                }
                .padding()
            }
            .navigationDestination(for: PathType.self) { pathType in
                pathType.NavigatingView()
            }
            .onAppear {
                viewModel.createGoals(modelContext: modelContext) // 온보딩 등장시 루틴 데이터 생성
                viewModel.createAllCloverData(modelContext: modelContext) // 온보딩 등장시 클로버 데이터 생성
            }
        }
        .environment(navigationManager)
    }
}

#Preview {
    OnboardingStartView()
        .environment(NavigationManager())
        .modelContainer(for: [MainGoal.self, SubGoal.self, DetailGoal.self], inMemory: true) // 임시 컨테이너 생성
}
