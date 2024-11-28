//
//  CloverCardView.swift
//  OneByte
//
//  Created by 이상도 on 11/28/24.
//

import SwiftUI

struct CloverCardView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State var viewModel = CloverCardViewModel()
    
    @State private var isCheckAchievement = false
    @State private var rotationAngle: Double = 0 // 회전 각도 상태 추가
    
    let cloverState: Int?
    
    var body: some View {
        let cloverCardType = viewModel.getCloverCardType(for: cloverState)
        
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
                        .foregroundStyle(.white)
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
                                .foregroundStyle(.myFFF6D3)
                            Text(cloverCardType.cloverType)
                                .font(.Pretendard.ExtraBold.size24)
                                .foregroundStyle(.white)
                        }
                        .padding(.top, 46)
                        
                        Image(cloverCardType.cloverCardClover) // 클로버 아이콘
                            .rotation3DEffect(
                                .degrees(rotationAngle),
                                axis: (x: 0, y: 1, z: 0)
                            )
                            .onAppear {
                                startRotationAnimation() // 애니메이션 시작
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
                    completionRateView()
                        .transition(.move(edge: .bottom))
                }
                
                Spacer()
            }
            Button {
                // action 뷰이동
            } label: {
                Text("클로버 모아보기")
                    .font(.Pretendard.SemiBold.size17)
                    .foregroundStyle(.myFBAC08)
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
    }
    
    @ViewBuilder
    private func completionRateView() -> some View {
        VStack(spacing: 12) {
            Text("12월 4주차의 루틴 완수율") // 저번주 날짜 데이터 넣기
                .font(.Pretendard.Bold.size17)
                .foregroundStyle(.my575656)
                .padding(.vertical, 10)
            
            ForEach(0..<4) { _ in
                HStack {
                    Text("키워드1")
                        .font(.Pretendard.Bold.size12)
                        .foregroundStyle(.my505050)
                        .frame(width: 62, alignment: .leading)
                    CloverCardProgressBar(value: 0.7)
                        .progressViewStyle(LinearProgressViewStyle(tint: .myFFA64A))
                }
                .padding(.horizontal, 33)
            }
        }
        .padding()
        .background(.myF2EAD0)
        .cornerRadius(16)
        .padding(.horizontal, 17)
        .padding(.top, 2)
    }
    
    // 회전 애니메이션 함수
    private func startRotationAnimation() {
        withAnimation(
            Animation.linear(duration: 2.0) // 애니메이션 지속 시간
                .repeatForever(autoreverses: false) // 무한 반복
        ) {
            rotationAngle = 360 // Y축 기준으로 한 바퀴 회전
        }
    }
}

#Preview {
    CloverCardView(cloverState: 1)
}
