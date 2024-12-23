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
    @Binding var selectedTab: Int
    
    var body: some View {
        let cloverCardType = viewModel.getCloverCardType(for: viewModel.lastWeekCloverState)
        
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss()
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
                        Text(cloverCardType.cloverCardTitle) // 클로버 종류 획득 문구
                            .font(.setPretendard(weight: .bold, size: 24))
                            .foregroundStyle(.white)
                            .kerning(0.48)
                        Text(cloverCardType.cloverCardMessage) // 메세지
                            .font(.setPretendard(weight: .medium, size: 16))
                            .foregroundStyle(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .kerning(0.32)
                            .lineSpacing(1.35)
                    }
                    .padding(.top, 26)
                    
                    ZStack { // (around padding 12)
                        Image(cloverCardType.cloverCardBackground) // 카드 배경
                            .resizable()
                            .scaledToFit()
                            .frame(width: 279, height: 360)
                        
                        VStack {
                            VStack(spacing: 2) {
                                Text(viewModel.getLastWeekWeekofMonth()) // 이전 주차
                                    .font(.setPretendard(weight: .bold, size: 18))
                                    .foregroundStyle(cloverCardType.cloverLastWeekDateColor)
                                Text(cloverCardType.cloverType)
                                    .font(.setPretendard(weight: .extraBold, size: 24))
                                    .foregroundStyle(.white)
                            }
                            .padding(.top, 48)
                            
                            Image(cloverCardType.cloverCardClover ?? "") // 클로버 아이콘
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
                                .font(.setPretendard(weight: .bold, size: 18))
                                .foregroundStyle(.white)
                        } else {
                            Text("루틴 완수율 확인하기")
                                .font(.setPretendard(weight: .bold, size: 18))
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
                selectedTab = 2 // 나의 클로버 뷰로 이동
                dismiss()
            } label: {
                Text("클로버 모아보기")
                    .font(.setPretendard(weight: .semiBold, size: 17))
                    .foregroundStyle(cloverCardType.buttonColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(.myFFFAF4)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(cloverCardType.gradient.ignoresSafeArea(edges: .all))
        .onAppear {
            // 저번주의 CloverState 값 찾기
            viewModel.lastWeekCloverState = viewModel.getLastWeekCloverState(clovers: clovers)
            print("🚧 저번주의 CloverState : \(String(describing: viewModel.lastWeekCloverState))")
            
            // 현재 루틴들의 achieve 계산하여 ProgressValue로 변환
            if let subGoals = mainGoals.first?.subGoals {
                viewModel.calculateProgressValues(for: subGoals)
            }
            
            // 주차 초기화
            let resetManager = WeeklyResetService()
            resetManager.performReset(goals: mainGoals, modelContext: modelContext)
        }
    }
    
    @ViewBuilder
    private func completionRateView(cloverCardType: CloverCardType) -> some View {
        let sortedSubGoals = mainGoals.first?.subGoals.sorted(by: { $0.id < $1.id }) ?? []
        let progressData = sortedSubGoals.map { subGoal in
            (id: subGoal.id, category: subGoal.category, progress: viewModel.progressValues[subGoal.id] ?? 0.0)
        }
        
        VStack(spacing: 12) {
            Text("\(viewModel.getLastWeekWeekofMonth())의 루틴 완수율") // 이전 주차
                .font(.setPretendard(weight: .bold, size: 17))
                .foregroundStyle(.my575656)
                .padding(.vertical, 10)
            
            ForEach(progressData, id: \.id) { data in
                HStack {
                    Text(data.category == "" ? "카테고리 없음" : data.category) // 나중에 온보딩에서 카테고리까지 선택하게되면, 수정 바람
                        .font(.setPretendard(weight: .bold, size: 12))
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
        .background(cloverCardType.completionRateBackgroundColor)
        .cornerRadius(16)
        .padding(.horizontal)
        .padding(.top, 2)
    }
}

#Preview {
    CloverCardView(selectedTab: .constant(2))
}
