//
//  OnboardingStartView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

struct OnboardingStartView: View {
    
    @Environment(\.modelContext) private var modelContext
    @State private var navigationManager = NavigationManager()
    
    @State var viewModel = OnboardingViewModel(createService: ClientCreateService(), updateService: ClientUpdateService(mainGoals: [], subGoals: [], detailGoals: []))
    
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
                    Image("Dara1")
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
                viewModel.createGoals(modelContext: modelContext) // 온보딩 등장시 데이터 생성
                viewModel.printAllData()
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
