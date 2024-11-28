//
//  CloverCardView.swift
//  OneByte
//
//  Created by 이상도 on 11/28/24.
//

import SwiftUI

struct CloverCardView: View {
    
    @State private var isCheckAchievement = false
    @State private var rotationAngle: Double = 0 // 회전 각도 상태 추가
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 3) {
                    Text("황금클로버를 획득했어요!") // clvosrState에 따라 다르게
                        .font(.Pretendard.Bold.size24)
                        .foregroundStyle(.white)
                    Text("잘하고 있어요! 앞으로도 지금처럼만 노력해봐요")
                        .font(.Pretendard.Medium.size16)
                        .foregroundStyle(.white)
                }
                .padding(.top, 32)
                
                ZStack {
                    Image("GoldCloverBackground")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 279, height: 360)
                    
                    VStack {
                        VStack(spacing: 2) {
                            Text("12월 4주차") // 저번주차 데이터
                                .font(.Pretendard.Bold.size18)
                                .foregroundStyle(.myFFF6D3)
                            Text("황금 클로버")
                                .font(.Pretendard.ExtraBold.size24)
                                .foregroundStyle(.white)
                        }
                        .padding(.top, 46)
                        
                        Image("GoldClover")
                            .rotation3DEffect(
                                .degrees(rotationAngle), // 상태에 따른 회전 각도
                                axis: (x: 0, y: 1, z: 0) // Y축 기준 회전
                                
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
        .background(.blue)
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
    CloverCardView()
}
