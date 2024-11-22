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
    
    
    var nowOnboard: Onboarding = .start
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack {
                Spacer()
                // 상단 텍스트
                VStack(spacing: 10) {
                    Text(nowOnboard.onboardingTitle)
                        .font(.Pretendard.Bold.size26)
                    
                    Text(nowOnboard.onboardingSubTitle)
                        .font(.Pretendard.Regular.size18)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                }
                Spacer()
                
                // 중앙 캐릭터 이미지
                HStack {
                    Image("Turtle_1")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 215)
                }
                .padding()
                
                Spacer()
                
                // 하단 Button
                GoButton {
                    navigationManager.push(to: .onboardQuestion)
                } label: {
                    Text("목표 세우러 가기")
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
