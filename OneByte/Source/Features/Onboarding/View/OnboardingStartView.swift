//
//  OnboardingStartView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

struct OnboardingStartView: View {
    
    @State private var navigationManager = NavigationManager()
    
    @Environment(\.modelContext) private var modelContext
    
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
                    Image(systemName: "timelapse")
                        .resizable()
                        .frame(width: 300, height: 300)
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
                viewModel.createGoals(modelContext: modelContext)
            }
        }
        .environment(navigationManager)
    }
}

#Preview {
    OnboardingStartView()
        .environment(NavigationManager())
}
