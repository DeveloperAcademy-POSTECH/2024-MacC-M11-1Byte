//
//  MyPageView.swift
//  OneByte
//
//  Created by 트루디 on 10/17/24.
//

import SwiftUI
import SwiftData

struct StatisticView: View {

    @State var viewModel = StatisticViewModel()
    
    var body: some View {
        ScrollView {
            VStack{
                // 최상단 헤더
                HStack {
                    Text("통계")
                        .font(.Pretendard.Bold.size22)
                        .foregroundStyle(Color.myB4A99D)
                    
                    Spacer()
                }
                .padding()
                
                // 이번달 클로버 정보
                thisMonthCloverInfoView()
                
                // 올해의 클로버 정보
                thisYearCloverInfoView()
                
                Spacer()
            }
        }
        .background(Color.myFFFAF4)
    }
    
    @ViewBuilder
    private func thisMonthCloverInfoView() -> some View {
        
        let cloverGetThisMonth = viewModel.getCurrentMonthClovers()
        let cloverStates = viewModel.classifyCloverState(clovers: cloverGetThisMonth)
    
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.my6FB56F)
                .frame(maxWidth: .infinity)
                .frame(height: 146)
                .padding()
            
            VStack {
                HStack {
                    Spacer()
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 83, height: 24)
                        .background(.white.opacity(0.8))
                        .cornerRadius(22.5)
                        .overlay(
                            HStack(spacing: 10) {
                                Text("\(cloverStates[2])개")
                                Text("\(cloverStates[1])개")
                            }
                        )
                        .padding(.trailing, 30)
                        .padding(.top)
                }
                .padding(.top)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("\(viewModel.getPofileNickName())님! \n이번 달 클로버를 \(cloverGetThisMonth.count)번 획득했어요") // member의 이름으로 "김만복" 대체해야 함
                    .font(
                        Font.custom("Pretendard", size: 20)
                            .weight(.bold)
                    )
                    .foregroundColor(.white)
                
                Text("모든 성장은 작은 시도에서 시작된답니다.\n다음 목표부터 하나씩 도전해볼까요?")
                    .font(.Pretendard.SemiBold.size14)
                    .foregroundColor(Color.my4A4A4A)
                    .frame(width: 227, alignment: .leading)
            }
            .padding(.leading, 41)
            .padding(.top, 26)
            .padding(.bottom, 20)
            
            
        }
    }
    
    @ViewBuilder
    private func thisYearCloverInfoView() -> some View {
        
        let cloverStates = viewModel.getCurrentYearCloverStates()
        
        VStack(spacing: 5){
            HStack {
                Text("올해의 클로버")
                    .font(.Pretendard.SemiBold.size18)
                    .padding(.leading, 5)
                Spacer()
            }
            HStack {
                Text("올해의 내가 수집한 클로버를 모아볼 수 있어요.")
                    .font(.caption)
                    .foregroundStyle(Color.myA8A8A8)
                    .padding(.leading, 5)
                Spacer()
            }
            
            HStack(alignment: .center) {
                VStack(spacing: 10) {
                    HStack {
                        Text("내가 모은 황금 클로버")
                            .font(.Pretendard.Medium.size15)
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "star.fill")
                        Text("\(cloverStates[2])")
                            .font(
                                Font.custom("SF Pro", size: 20)
                                    .weight(.semibold)
                            )
                        Spacer()
                    }
                }
                .padding(.leading)
                
                Divider()
                    .frame(height: 60)
                    .background(Color.myD5D5D5)
                
                VStack(spacing: 10) {
                    HStack {
                        Text("내가 모은 클로버")
                            .font(.Pretendard.Medium.size15)
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "star.fill")
                        
                        Text("\(cloverStates[1])")
                            .font(
                                Font.custom("SF Pro", size: 20)
                                    .weight(.semibold)
                            )
                        Spacer()
                    }
                }
                .padding(.leading)
                
                // ⚠️⚠️ 추가 구현
            }
            .frame(maxWidth: .infinity)
            .frame(height: 82)
            .background(.white)
            .cornerRadius(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.myF0E8DF, lineWidth: 1)
            )
            .padding(.top, 5)
        }
        .padding()
    }
}

#Preview {
    let sampleViewModel = StatisticViewModel()
    
    sampleViewModel.clovers = [
        Clover(id: 1, cloverYear: 2024, cloverMonth: 1, cloverWeekOfMonth: 1, cloverWeekOfYear: 1, cloverState: 1),
        Clover(id: 2, cloverYear: 2024, cloverMonth: 1, cloverWeekOfMonth: 2, cloverWeekOfYear: 2, cloverState: 2),
        Clover(id: 3, cloverYear: 2024, cloverMonth: 1, cloverWeekOfMonth: 3, cloverWeekOfYear: 3, cloverState: 0),
        Clover(id: 4, cloverYear: 2024, cloverMonth: 1, cloverWeekOfMonth: 4, cloverWeekOfYear: 4, cloverState: 1),
        Clover(id: 5, cloverYear: 2024, cloverMonth: 1, cloverWeekOfMonth: 5, cloverWeekOfYear: 5, cloverState: 1),
        Clover(id: 6, cloverYear: 2024, cloverMonth: 2, cloverWeekOfMonth: 1, cloverWeekOfYear: 6, cloverState: 2),
        Clover(id: 7, cloverYear: 2024, cloverMonth: 2, cloverWeekOfMonth: 2, cloverWeekOfYear: 7, cloverState: 1),
        Clover(id: 8, cloverYear: 2024, cloverMonth: 2, cloverWeekOfMonth: 3, cloverWeekOfYear: 8, cloverState: 0),
        Clover(id: 9, cloverYear: 2024, cloverMonth: 2, cloverWeekOfMonth: 4, cloverWeekOfYear: 9, cloverState: 1),
        Clover(id: 10, cloverYear: 2024, cloverMonth: 11, cloverWeekOfMonth: 1, cloverWeekOfYear: 44, cloverState: 1),
        Clover(id: 11, cloverYear: 2024, cloverMonth: 11, cloverWeekOfMonth: 2, cloverWeekOfYear: 45, cloverState: 2),
        Clover(id: 12, cloverYear: 2024, cloverMonth: 11, cloverWeekOfMonth: 3, cloverWeekOfYear: 46, cloverState: 1),
    ]
    
    sampleViewModel.profile = Profile(nickName: "빈치")
    return StatisticView(viewModel: sampleViewModel)
    
}
