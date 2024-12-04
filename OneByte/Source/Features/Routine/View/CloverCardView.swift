//
//  CloverCardView.swift
//  OneByte
//
//  Created by 이상도 on 11/28/24.
//

import SwiftUI
import SwiftData

struct CloverCardView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Query var mainGoals: [MainGoal]
    @Query var clovers: [Clover]
    @Environment(\.modelContext) private var modelContext
    @State var viewModel = CloverCardViewModel()
//    @Binding var selectedTab: Int
    @Binding var isNextWeek: Bool
    
    var body: some View {
        let cloverCardType = viewModel.getCloverCardType(for: viewModel.lastWeekCloverState)
        
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss()
                    isNextWeek.toggle()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .tint(.white)
                            .bold()
                            .frame(width: 17, height: 22)
                    }
                }
                Spacer()
            }
            .padding(.leading)
            .padding(.vertical, 11)
            
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 9) {
                        Text("초록 클로버를 획득했어요!")
//                        Text(cloverCardType.cloverCardTitle) // 클로버 종류 획득 문구
                            .font(.Pretendard.Bold.size24)
                            .foregroundStyle(.white)
                            .kerning(0.48)
                        Text("한 주 동안 너무 수고했어요\n이번 주에는 황금클로버에도 도전해봐요!")
//                        Text(cloverCardType.cloverCardMessage) // 메세지
                            .font(.Pretendard.Medium.size16)
                            .foregroundStyle(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .kerning(0.32)
                            .lineSpacing(1.35)
                    }
                    .padding(.top, 26)
                    
                    ZStack { // (around padding 12)
                        Image("GreenCloverBackground")
//                        Image(cloverCardType.cloverCardBackground) // 카드 배경
                            .resizable()
                            .scaledToFit()
                            .frame(width: 279, height: 360)
                        
                        VStack {
                            VStack(spacing: 2) {
                                Text("12월 1주차") // 이전 주차
                                    .font(.Pretendard.Bold.size18)
                                    .foregroundStyle(.myD7FFD3)
                                Text("초록 클로버")
                                    .font(.Pretendard.ExtraBold.size24)
                                    .foregroundStyle(.white)
                            }
                            .padding(.top, 48)
                            
                            Image("GreenClover") // 클로버 아이콘
                                .rotation3DEffect (
                                    .degrees(viewModel.rotationAngle),
                                    axis: (x: 0, y: 1, z: 0)
                                )
                                .onAppear {
                                    viewModel.startRotationAnimation() // 자동 회전
                                }
                                .onTapGesture {
                                    viewModel.tapRotationAnimation() // 탭 회전
                                }
                                .padding(.top, 30)
                            Spacer()
                        }
                    }
                    .frame(width: 279, height: 360)
                    
                    VStack(spacing: 6) {
                        if viewModel.isCheckAchievement {
                            Image(systemName: "chevron.up")
                                .frame(width: 19, height: 11)
                                .foregroundStyle(.white)
                                .bold()
                            Text("완수율 확인하기")
                                .font(.Pretendard.Bold.size18)
                                .foregroundStyle(.white)
                        } else {
                            Text("루틴 완수율 확인하기")
                                .font(.Pretendard.Bold.size18)
                                .foregroundStyle(.white)
                            Image(systemName: "chevron.down")
                                .frame(width: 19, height: 11)
                                .foregroundStyle(.white)
                        }
                    }
                    .padding(.top, 2)
                    .onTapGesture {
                        viewModel.isCheckAchievement.toggle()
                        if viewModel.isCheckAchievement {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation {
                                    proxy.scrollTo("scrollToBottom", anchor: .bottom)
                                }
                            }
                        }
                    }
                    // 완수율 통계
                    if viewModel.isCheckAchievement {
                        completionRateView(cloverCardType: cloverCardType)
                            .transition(.move(edge: .bottom))
                            .id("scrollToBottom")
                    }
                    Spacer()
                }
            }
            
            Button {
//                selectedTab = 2 // 나의 클로버 뷰로 이동
//                statViewModel.isNextWeek.toggle()
                isNextWeek.toggle()
                dismiss()
            } label: {
                Text("클로버 모아보기")
                    .font(.Pretendard.SemiBold.size17)
                    .foregroundStyle(.my538F53)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(.myFFFAF4)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
                   LinearGradient(
                       gradient: Gradient(stops: [
                           Gradient.Stop(color: .my3A933A, location: 0.0),
                           Gradient.Stop(color: .my95D895, location: 1.0),
                       ]),
                       startPoint: .top,
                       endPoint: .bottom
                   )
                   .ignoresSafeArea(edges: .all)
               )
        .onAppear {
//            // 저번주의 CloverState 값 찾기
//            viewModel.lastWeekCloverState = viewModel.getLastWeekCloverState(clovers: clovers)
//            print("🚧 저번주의 CloverState : \(String(describing: viewModel.lastWeekCloverState))")
//            // 현재 루틴들의 achieve 계산하여 ProgressValue로 변환
            if let subGoals = mainGoals.first?.subGoals {
                viewModel.calculateProgressValues(for: subGoals)
            }
//            let resetManager = WeeklyResetManager()
//            resetManager.performReset(goals: mainGoals, modelContext: modelContext)
        }
    }
    
    @ViewBuilder
    private func completionRateView(cloverCardType: CloverCardType) -> some View {
        let sortedSubGoals = mainGoals.first?.subGoals.sorted(by: { $0.id < $1.id }) ?? []
        let progressData = sortedSubGoals.map { subGoal in
            (id: subGoal.id, category: subGoal.category, progress: viewModel.progressValues[subGoal.id] ?? 0.0)
        }
        
        VStack(spacing: 12) {
            Text("12월 1주차의 루틴 완수율") // 이전 주차
                .font(.Pretendard.Bold.size17)
                .foregroundStyle(.my575656)
                .padding(.vertical, 10)
            
            ForEach(progressData, id: \.id) { data in
                HStack {
                    Text(data.category == "" ? "카테고리 없음" : data.category)
                        .font(.Pretendard.Bold.size12)
                        .foregroundStyle(.my505050)
                        .frame(width: 66, alignment: .leading)
                    CloverCardProgressBar(value: data.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .myFFA64A))
                        .padding(.top, 3)
                }
                .padding(.horizontal, 33)
            }
        }
        .padding()
        .background(.myD5E3D5)
        .cornerRadius(16)
        .padding(.horizontal)
        .padding(.top, 2)
    }
}

//#Preview {
//    CloverCardView(selectedTab: .constant(2))
//}
