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
    @Query var clovers: [Clover]
    @Query var profile: [Profile]
    @State var viewModel = StatisticViewModel()
    
    var body: some View {
        NavigationStack{
            VStack(spacing: 0){
                HStack {
                    Text("통계")
                        .font(.Pretendard.Bold.size22)
                        .foregroundStyle(Color.myB4A99D)
                    
                    Spacer()
                    
                    NavigationLink {
                        SettingView()
                    } label: {
                        Image(systemName: "gear")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.my566956)
                    }
                    .padding(.vertical)
                }
                ScrollView {
                    thisMonthCloverInfoView()
                        .padding(.top, 52)
                    thisYearCloverInfoView()
                        .padding(.top, 40)
                    weeklyCloverInfoView()
                        .padding(.top, 10)
                    
                    Spacer()
                }
            }
            .padding(.horizontal, 20)
            .background(Color.myFFFAF4)
            .onAppear {
                viewModel.setClovers(clovers)
                viewModel.setProfile(profile)
            }
        }
    }
    
    @ViewBuilder
    private func thisMonthCloverInfoView() -> some View {
        ZStack(alignment: .leading) {
            HStack {
                Spacer()
                VStack {
                    Image("Turtle_Body")
                    Spacer()
                }
                .padding(.top, -44)
                .padding(.trailing, 25)
            }
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.my6FB56F)
                .frame(maxWidth: .infinity)
                .frame(height: 146)
            
            HStack {
                Spacer()
                Image("Clover_Back")
                    .frame(width: 130, height: 130)
                    .padding(.trailing, 10)
            }
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    VStack(spacing: 0) {
                        Image("Turtle_Hands")
                            .padding(.trailing, 16.97)
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
                            .padding(.top, 1.05)
                    }
                }
                .padding(.trailing, 10)
                .padding(.top, -12)
                Spacer()
                
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("\(viewModel.profileNickName)님! \n이번 달 클로버를 \(viewModel.currentMonthClovers.count)개 획득했어요")
                    .font(.Pretendard.Bold.size20)
                    .foregroundStyle(.white)
                
                Text("모든 성장은 작은 시도에서 시작된답니다.\n다음 목표부터 하나씩 도전해볼까요?")
                    .font(.Pretendard.SemiBold.size14)
                    .foregroundStyle(Color.my4A4A4A)
                    .frame(width: 227, alignment: .leading)
            }
            .padding(.leading, 21)
            .padding(.top, 26)
            .padding(.bottom, 20)
        }
    }
    
    
    
    @ViewBuilder
    private func thisYearCloverInfoView() -> some View {
        VStack(spacing: 10){
            VStack(spacing: 2) {
                HStack {
                    Text("올해의 클로버")
                        .font(.Pretendard.SemiBold.size18)
                        .padding(.leading, 5)
                    Spacer()
                }
                HStack {
                    Text("올해의 내가 수집한 클로버를 모아볼 수 있어요.")
                        .font(.Pretendard.Medium.size14)
                        .foregroundStyle(Color.myA8A8A8)
                        .padding(.leading, 5)
                    Spacer()
                }
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
                            .font(.Pretendard.SemiBold.size20)
                        Spacer()
                    }
                }
                .padding(.leading, 20)
                
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
                            .font(.Pretendard.SemiBold.size20)
                        Spacer()
                    }
                }
                .padding(.leading, 20)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 82)
            .background(.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.myF0E8DF, lineWidth: 1)
            )
        }
    }
    
    @ViewBuilder
    private func weeklyCloverInfoView() -> some View {
        @State var rectangleHeight = viewModel.weeklyCloverInfoHeight
        ZStack(alignment: .top) {
            Rectangle()
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: viewModel.weeklyCloverInfoHeight)
                .cornerRadius(13)
                .overlay(
                    RoundedRectangle(cornerRadius: 13)
                        .stroke(Color.myF0E8DF, lineWidth: 1)
                )
            
            VStack(spacing: 11) {
                if let range = viewModel.currentYearCloverMonthRange {
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
                    .padding(.top, 18)
                    .padding(.bottom, 9)
                    
                    ForEach(Array(stride(from: viewModel.currentMonth, through: range.min, by: -1)), id: \.self) { month in // 내림차순
                        let cloversForMonth = viewModel.filterCloversByMonth(clovers: viewModel.currentYearClovers, month: month)
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
                            }
                            if viewModel.weeklyCloverInfoHeight > 100 {
                                Divider()
                                    .padding(.horizontal, 12)
                            }
                            
                        }
                    }
                } else {
                    Text("클로버를 찾을 수 없습니다")
                        .font(.Pretendard.Regular.size16)
                        .padding(.top, 12)
                }
            }
        }
    }
}

#Preview {
    StatisticView()
}

