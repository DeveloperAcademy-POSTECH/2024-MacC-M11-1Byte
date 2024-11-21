//
//  MyPageView.swift
//  OneByte
//
//  Created by 트루디 on 10/17/24.
//

import SwiftUI
import SwiftData

struct StatisticView: View {
    @Environment(\.modelContext) private var modelContext
    
    @StateObject var viewModel = StatisticViewModel()
    
    var body: some View {
        ScrollView {
            VStack{
                HStack {
                    Text("통계")
                        .font(.Pretendard.Bold.size22)
                        .foregroundStyle(Color.myB4A99D)
                    
                    Spacer()
                }
                .padding()
            
                thisMonthCloverInfoView()
                
                thisYearCloverInfoView()
                
                weeklyCloverInfoView()

                
                Spacer()
            }
        }
        .background(Color.myFFFAF4)
    }
    
    @ViewBuilder
    private func thisMonthCloverInfoView() -> some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.my6FB56F)
                .frame(maxWidth: .infinity)
                .frame(height: 146)
                .padding()
            HStack {
                Spacer()
                Image("Clover_Back")
                    .frame(width: 130, height: 130)
                    .padding(.trailing, 28)
            }
            VStack {
                HStack {
                    Spacer()
                    Rectangle()
                        .foregroundStyle(.clear)
                        .frame(width: 83, height: 24)
                        .background(.white.opacity(0.8))
                        .cornerRadius(22.5)
                        .overlay(
                            HStack(spacing: 5) {
                                Image("Clover_Gold")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                Text("\(viewModel.currentMonthCloverStates[2])")
                                    .font(.Pretendard.SemiBold.size12)
                                    .foregroundStyle(.myA7A7A7)
                                Image("Clover_Green")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                Text("\(viewModel.currentMonthCloverStates[1])")
                                    .font(.Pretendard.SemiBold.size12)
                                    .foregroundStyle(.myA7A7A7)
                            }
                        )
                        .padding(.trailing, 30)
                        .padding(.top, 10)
                }
                .padding(.top)
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("\(viewModel.profileNickName)님! \n이번 달 클로버를 \(viewModel.currentMonthClovers.count)번 획득했어요")
                    .font(.Pretendard.Bold.size20)
                    .foregroundStyle(.white)
                
                Text("모든 성장은 작은 시도에서 시작된답니다.\n다음 목표부터 하나씩 도전해볼까요?")
                    .font(.Pretendard.SemiBold.size14)
                    .foregroundStyle(Color.my4A4A4A)
                    .frame(width: 227, alignment: .leading)
            }
            .padding(.leading, 41)
            .padding(.top, 26)
            .padding(.bottom, 20)
        }
    }
    
    
    
    @ViewBuilder
    private func thisYearCloverInfoView() -> some View {
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
                        Image("Clover_Gold")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("\(viewModel.currentYearCloverStates[2])")
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
                        Image("Clover_Green")
                            .resizable()
                            .frame(width: 20, height: 20)
                        Text("\(viewModel.currentYearCloverStates[1])")
                            .font(
                                Font.custom("SF Pro", size: 20)
                                    .weight(.semibold)
                            )
                        Spacer()
                    }
                }
                .padding(.leading)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 82)
            .background(.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12) // 테두리 추가
                    .stroke(Color.myF0E8DF, lineWidth: 1) // 테두리 색상과 두께 설정
            )
            .padding(.top, 5)
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
    @ViewBuilder
    private func weeklyCloverInfoView() -> some View {
        ZStack(alignment: .top) {
            Rectangle()
                .foregroundStyle(.white)
                .frame(width: .infinity, height: viewModel.weeklyCloverInfoHeight)
                .cornerRadius(13)
                .overlay(
                    RoundedRectangle(cornerRadius: 13) // 테두리 추가
                        .stroke(Color.myF0E8DF, lineWidth: 1) // 테두리 색상과 두께 설정
                )
                .padding()
            VStack(spacing: 20) {
                HStack(spacing: 30) {
                    Spacer()
                        .frame(width: 20)
                    Text("1주차")
                        .font(Font.Pretendard.SemiBold.size12)
                        .foregroundStyle(.my9C9C9C)
                    Text("2주차")
                        .font(Font.Pretendard.SemiBold.size12)
                        .foregroundStyle(.my9C9C9C)
                    Text("3주차")
                        .font(Font.Pretendard.SemiBold.size12)
                        .foregroundStyle(.my9C9C9C)
                    Text("4주차")
                        .font(Font.Pretendard.SemiBold.size12)
                        .foregroundStyle(.my9C9C9C)
                    Text("5주차")
                        .font(Font.Pretendard.SemiBold.size12)
                        .foregroundStyle(.my9C9C9C)
                }
                
                if let range = viewModel.currentYearCloverMonthRange {
                    ForEach(Array(stride(from: viewModel.currentMonth, through: range.min, by: -1)), id: \.self) { month in // 내림차순
                        let cloversForMonth = viewModel.filterCloversByMonth(clovers: viewModel.clovers, month: month)
                        VStack(spacing: 9) {
                            HStack(spacing: 20) {
                                Text("\(month)월")
                                    .font(Font.Pretendard.Bold.size14)
                                    .foregroundStyle(.my566956)
                                    .frame(width: 30)
                                
                                ForEach(1...5, id: \.self) { week in
                                    let cloverForWeek = cloversForMonth.filter { $0.cloverWeekOfMonth == week }
                                    
                                    if let firstClover = cloverForWeek.first {
                                        switch firstClover.cloverState {
                                        case 0:
                                            Image("Clover_Empty")
                                                .resizable()
                                                .frame(width: 38, height: 38)
                                        case 1:
                                            Image("Clover_Light")
                                                .resizable()
                                                .frame(width: 38, height: 38)
                                        case 2:
                                            Image("Clover_Green")
                                                .resizable()
                                                .frame(width: 38, height: 38)
                                        case 3:
                                            Image("Clover_Gold")
                                                .resizable()
                                                .frame(width: 38, height: 38)
                                        default:
                                            Image("Clover_Empty")
                                                .resizable()
                                                .frame(width: 38, height: 38)
                                        }
                                    } else {
                                        Image("Clover_Empty")
                                            .resizable()
                                            .frame(width: 38, height: 38)
                                    }
                                }
                            }.padding(.top, -9)
                            Divider()
                                .padding(.horizontal, 30)
                                
                        }
                        
                        
                    }
                } else {
                    Text("No data available for the current year")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                }
            }
            .padding(.top, 28)
            
        }
        
    }
}

#Preview {
    StatisticView()
}

