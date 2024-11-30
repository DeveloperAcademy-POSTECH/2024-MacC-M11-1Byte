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
    
    @State private var isCheckAchievement = false // 완수율 확인하기
    @State private var rotationAngle: Double = 0 // 회전 각도
    @State private var isTapped: Bool = false  // 애니메이션 자동회전/탭회전 구분
    
    @State var lastWeekCloverState: Int? // 지난주의 cloverState 값
    
    var body: some View {
        let cloverCardType = viewModel.getCloverCardType(for: lastWeekCloverState)
        
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .tint(.white)
                            .frame(width: 17, height: 22)
                            .bold()
                    }
                }
                Spacer()
            }
            .padding(.leading, 16)
            .padding(.bottom, 11)
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 3) {
                    Text(cloverCardType.cloverCardTitle) // 클로버 종류
                        .font(.Pretendard.Bold.size24)
                        .foregroundStyle(.white)
                    Text(cloverCardType.cloverCardMessage) // 메세지
                        .font(.Pretendard.Medium.size16)
                        .foregroundStyle(.white.opacity(0.9))
                }
                .padding(.top, 32)
                
                ZStack {
                    Image(cloverCardType.cloverCardBackground) // 카드 배경
                        .resizable()
                        .scaledToFit()
                        .frame(width: 279, height: 360)
                    
                    VStack {
                        VStack(spacing: 2) {
                            Text(viewModel.getLastWeekWeekofMonth()) // 이전 주차
                                .font(.Pretendard.Bold.size18)
                                .foregroundStyle(cloverCardType.cloverLastWeekDateColor)
                            Text(cloverCardType.cloverType)
                                .font(.Pretendard.ExtraBold.size24)
                                .foregroundStyle(.white)
                        }
                        .padding(.top, 46)
                        
                        Image(cloverCardType.cloverCardClover ?? "") // 클로버 아이콘
                            .rotation3DEffect(
                                .degrees(rotationAngle),
                                axis: (x: 0, y: 1, z: 0)
                            )
                            .onAppear {
                                startRotationAnimation() // 자동 회전
                            }
                            .onTapGesture {
                                tapRotationAnimation() // 탭 회전
                            }
                            .padding(.top, 30)
                        
                        Spacer()
                    }
                }
                .padding(.top, 39)
                .frame(width: 279, height: 360)
                
                VStack(spacing: 6) {
                    if isCheckAchievement {
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
                            .bold()
                    }
                }
                .padding(.top, 24)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        isCheckAchievement.toggle()
                    }
                }
                
                // 완수율 통계
                if isCheckAchievement {
                    completionRateView(cloverCardType: cloverCardType)
                        .transition(.move(edge: .bottom))
                }
                
                Spacer()
            }
            Button {
                // action 뷰이동
            } label: {
                Text("클로버 모아보기")
                    .font(.Pretendard.SemiBold.size17)
                    .foregroundStyle(cloverCardType.buttonColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(.myFFFAF4)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 17)
            .padding(.vertical)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(cloverCardType.gradient.ignoresSafeArea(edges: .all))
        .onAppear {
            lastWeekCloverState = viewModel.getLastWeekCloverState(clovers: clovers)
            print("(지난 주 클로버 상태: \(lastWeekCloverState)")
        }
    }
    
    @ViewBuilder
    private func completionRateView(cloverCardType: CloverCardType) -> some View {
        VStack(spacing: 12) {
            Text(viewModel.getLastWeekWeekofMonth()) // 이전 주차
                .font(.Pretendard.Bold.size17)
                .foregroundStyle(.my575656)
                .padding(.vertical, 10)
            
            // SubGoal의 category를 표시
            ForEach(mainGoals.first?.subGoals.sorted(by: { $0.id < $1.id }) ?? [], id: \.id) { subGoal in
                HStack {
                    Text(subGoal.category) // SubGoal의 category 표시
                        .font(.Pretendard.Bold.size12)
                        .foregroundStyle(.my505050)
                        .frame(width: 62, alignment: .leading)
                    CloverCardProgressBar(value: 0.7) // 진행률은 임시값
                        .progressViewStyle(LinearProgressViewStyle(tint: .myFFA64A))
                }
                .padding(.horizontal, 33)
            }
        }
        .padding()
        .background(cloverCardType.completionRateBackgroundColor)
        .cornerRadius(16)
        .padding(.horizontal, 17)
        .padding(.top, 2)
    }
    
    // 클로버 자동 회전
    private func startRotationAnimation() {
        guard !isTapped else { return } // 탭 회전 중이면 무시
        withAnimation(
            Animation.linear(duration: 2.5) // 애니메이션 지속 시간
                .repeatForever(autoreverses: false) // 무한 반복
        ) {
            rotationAngle += 360 // Y축 기준으로 한 바퀴 회전
        }
    }
    
    // 클로버 탭 회전
    private func tapRotationAnimation() {
        guard !isTapped else { return } // 이미 빠른 회전 중이면 무시
        isTapped = true
        
        // 탭 회전 시작
        withAnimation(
            Animation.linear(duration: 1.0)
        ) {
            rotationAngle += 90
        }
        
        withAnimation(
            Animation.linear(duration: 1.4)
        ) {
            rotationAngle += 90
        }
        
        withAnimation(
            Animation.linear(duration: 1.8)
        ) {
            rotationAngle += 90
        }
        
        withAnimation(
            Animation.linear(duration: 2.2)
        ) {
            rotationAngle += 90
        }
        
        // 자동 회전으로 복귀
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isTapped = false
            startRotationAnimation()
        }
    }
}

#Preview {
    CloverCardView(lastWeekCloverState: 2)
}
