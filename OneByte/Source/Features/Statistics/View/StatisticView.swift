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
    @State var isOpenedWeeklyCloverInfo = false
    @State private var isQuestionMarkClicked = false
    @Binding var isTabBarMainVisible: Bool
    
    @State private var showCloverCardView: Bool = false  // 클로버 카드뷰 제어
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.myFFFAF4
                    .ignoresSafeArea(edges: .top)
                VStack(spacing: 0){
                    HStack {
                        Text("나의 클로버")
                            .font(.Pretendard.Bold.size22)
                            .foregroundStyle(Color.myB4A99D)
                            .onTapGesture {
                                viewModel.isNextWeek.toggle()
                            }
                        
                        Spacer()
                        
                        NavigationLink {
                            SettingView(isTabBarMainVisible: $isTabBarMainVisible)
                        } label: {
                            Image("SettingDark")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(Color.my566956)
                        }
                        .padding(.vertical)
                    }
                    .padding(.leading, 4)
                    .padding(.trailing, 10)
                    .padding(.top, -6)
                    ScrollView {
                        thisMonthCloverInfoView()
                            .padding(.top, 44)
                        
                        weeklyCloverInfoView()
                            .padding(.top, 21)
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
                .background(Color.myFFFAF4)
                .onAppear {
                    isTabBarMainVisible = true
                    viewModel.setClovers(clovers)
                    viewModel.setProfile(profile)
                }
                .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
                .fullScreenCover(isPresented: $showCloverCardView) {
                    CloverCardView(isNextWeek: $viewModel.isNextWeek)
                }
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
                .frame(height: 114)
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    VStack(spacing: 0) {
                        Image("Turtle_Hands")
                            .padding(.trailing, 16.97)
                            .padding(.top, 1.05)
                    }
                }
                .padding(.trailing, 10)
                .padding(.top, -12)
                Spacer()
                
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text(viewModel.getMonthInfoViewPhrase()[0])
                    .font(.Pretendard.Bold.size18)
                    .foregroundStyle(.white)
                Text(viewModel.getMonthInfoViewPhrase()[1])
                    .font(.Pretendard.Medium.size16)
                    .foregroundStyle(Color.myDCECDC)
            }
            .padding(.leading, 20)
            .padding(.vertical, 20)
        }
    }
    
    @ViewBuilder
    private func weeklyCloverInfoView() -> some View {
        @State var rectangleHeight = viewModel.weeklyCloverInfoHeight
        
        let minMonth = viewModel.currentYearCloverMonthRange.min
        let maxMonth = viewModel.currentYearCloverMonthRange.max
        
        let throughMonth = (maxMonth - minMonth > 2)
        ? (isOpenedWeeklyCloverInfo ? minMonth : maxMonth - 2)
        : minMonth
        
        let currentWeekOfMonth = viewModel.currentWeekOfMonth
        let currentWeekOfYear = viewModel.currentWeekOfYear
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 12) {
                VStack(spacing: 4) {
                    HStack {
                        Text("올해의 클로버")
                            .font(.Pretendard.SemiBold.size18)
                            .padding(.leading, 5)
                        Spacer()
                        Button(action: {
                            if isQuestionMarkClicked { isQuestionMarkClicked = false }
                            else { isQuestionMarkClicked = true }
                        }, label: {
                            Image(systemName: "questionmark.circle")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(.my8E8E8E)
                        })
                        .padding(.trailing, 6)
                    }
                    HStack {
                        Text("올해에 내가 수집한 클로버를 모아볼 수 있어요")
                            .font(.Pretendard.Medium.size14)
                            .foregroundStyle(Color.my909090)
                            .padding(.leading, 5)
                        Spacer()
                    }
                }
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: (viewModel.currentYearCloverMonthRange.max - viewModel.currentYearCloverMonthRange.min > 2) ? (isOpenedWeeklyCloverInfo ? viewModel.weeklyCloverInfoHeight : 388) : viewModel.weeklyCloverInfoHeight)
                        .cornerRadius(13)
                        .overlay(
                            RoundedRectangle(cornerRadius: 13)
                                .stroke(Color.myF0E8DF, lineWidth: 1)
                        )
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .top, spacing: 0) {
                            VStack(spacing: 7) {
                                HStack {
                                    Text("초록 클로버")
                                        .font(.Pretendard.Medium.size14)
                                        .foregroundStyle(Color.my909090)
                                }
                                HStack {
                                    Image("Clover_Green")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    Text("\(viewModel.currentYearCloverStates[1])개")
                                        .font(.Pretendard.SemiBold.size16)
                                }
                            }
                            
                            Divider()
                                .background(Color.myD5D5D5)
                                .padding(.horizontal, 59)
                                .frame(height: 46)
                            
                            VStack(spacing: 7) {
                                HStack {
                                    Text("황금 클로버")
                                        .font(.Pretendard.Medium.size14)
                                        .foregroundStyle(Color.my909090)
                                }
                                HStack {
                                    Image("Clover_Gold")
                                        .resizable()
                                        .frame(width: 20, height: 20)
                                    Text("\(viewModel.currentYearCloverStates[2])개")
                                        .font(.Pretendard.SemiBold.size16)
                                }
                            }
                        }
                        .padding(.leading, 59)
                        .padding(.top, 20)
                        
                        HStack(spacing: 28.5) {
                            Text("1주차")
                                .font(currentWeekOfMonth == 1 ? Font.Pretendard.Bold.size12 : Font.Pretendard.SemiBold.size12)
                                .foregroundStyle(.my887E78)
                            Text("2주차")
                                .font(currentWeekOfMonth == 2 ? Font.Pretendard.Bold.size12 : Font.Pretendard.SemiBold.size12)
                                .foregroundStyle(.my887E78)
                            Text("3주차")
                                .font(currentWeekOfMonth == 3 ? Font.Pretendard.Bold.size12 : Font.Pretendard.SemiBold.size12)
                                .foregroundStyle(.my887E78)
                            Text("4주차")
                                .font(currentWeekOfMonth == 4 ? Font.Pretendard.Bold.size12 : Font.Pretendard.SemiBold.size12)
                                .foregroundStyle(.my887E78)
                            Text("5주차")
                                .font(currentWeekOfMonth == 5 ? Font.Pretendard.Bold.size12 : Font.Pretendard.SemiBold.size12)
                                .foregroundStyle(.my887E78)
                        }
                        .padding(.top, 38)
                        .padding(.bottom, 9)
                        .padding(.leading, 81)
                        
                        ForEach(Array(stride(from: viewModel.currentMonth, through: throughMonth, by: -1)), id: \.self) { month in // 내림차순
                            let cloversForMonth = viewModel.filterCloversByMonth(clovers: viewModel.currentYearClovers, month: month)
                            VStack(alignment: .leading, spacing: 0) {
                                HStack(spacing: 16) {
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.myF0E8DF)
                                        .frame(width: 41, height: 29)
                                        .overlay(
                                            Text("\(month)월")
                                                .font(Font.Pretendard.SemiBold.size14)
                                                .foregroundStyle(.my887E78)
                                        )
                                    
                                    ForEach(1...5, id: \.self) { week in
                                        let cloverForWeek = cloversForMonth.filter { $0.cloverWeekOfMonth == week }
                                        
                                        if let firstClover = cloverForWeek.first {
                                            // 이번 주차는 클로버 상태를 표시하지 않음
                                            if firstClover.cloverWeekOfYear == currentWeekOfYear && firstClover.cloverWeekOfMonth == currentWeekOfMonth {
                                                Image("Clover_Empty")
                                                    .resizable()
                                                    .frame(width: 41, height: 41)
                                            } else {
                                                switch firstClover.cloverState {
                                                case 0:
                                                    Image("Clover_Empty")
                                                        .resizable()
                                                        .frame(width: 41, height: 41)
                                                case 1:
                                                    Image("Clover_Green")
                                                        .resizable()
                                                        .frame(width: 41, height: 41)
                                                case 2:
                                                    Image("Clover_Gold")
                                                        .resizable()
                                                        .frame(width: 41, height: 41)
                                                default:
                                                    Image("Clover_Empty")
                                                        .resizable()
                                                        .frame(width: 41, height: 41)
                                                }
                                            }
                                            
                                        } else {
                                            Rectangle()
                                                .fill(.clear)
                                                .frame(width: 41, height: 41)
                                        }
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.bottom, 32)
                            }
                        }
                        if (viewModel.currentYearCloverMonthRange.max - viewModel.currentYearCloverMonthRange.min > 2) {
                            Button(action: {
                                isOpenedWeeklyCloverInfo.toggle()
                            }) {
                                if (isOpenedWeeklyCloverInfo) {
                                    VStack(spacing: 2) {
                                        Image(systemName: "chevron.up")
                                            .frame(width: 16, height: 17)
                                            .foregroundStyle(.my887E78)
                                        Text("접기")
                                            .font(.Pretendard.SemiBold.size14)
                                            .foregroundStyle(.my887E78)
                                    }
                                    .frame(width: 78)
                                } else {
                                    VStack(spacing: 2) {
                                        Text("지난 달 더보기")
                                            .font(.Pretendard.SemiBold.size14)
                                            .foregroundStyle(.my887E78)
                                        Image(systemName: "chevron.down")
                                            .frame(width: 16, height: 17)
                                            .foregroundStyle(.my887E78)
                                    }
                                }
                            }
                            .padding(.top, -8)
                            .padding(.leading, 141)
                        }
                    }
                    RoundedRectangle(cornerRadius: 9)
                        .stroke(.my887E78, lineWidth: 1.5)
                        .frame(width: 56, height: 80)
                        .padding(.leading, 2 * CGFloat(currentWeekOfMonth)/12 + CGFloat(currentWeekOfMonth)/9 + CGFloat(currentWeekOfMonth)/6 + CGFloat(currentWeekOfMonth)/3 + 9 + 56 * CGFloat(currentWeekOfMonth))
                        .padding(.top, 96)
                }
                VStack(spacing: 4) {
                    HStack {
                        Text("클로버 카드 보기")
                            .font(.Pretendard.SemiBold.size18)
                            .padding(.leading, 5)
                        Spacer()
                    }
                    HStack {
                        Text("앱 체험을 위해 임시로 추가된 기능이에요")
                            .font(.Pretendard.Medium.size14)
                            .foregroundStyle(Color.my909090)
                            .padding(.leading, 5)
                        Spacer()
                    }
                    Button(action: {
                        showCloverCardView.toggle()
                    }, label: {
                        HStack(alignment: .center, spacing: 10) {
                            Text("이번 주 마무리하고, 클로버 카드 받기")
                                .font(.Pretendard.Medium.size14)
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 72)
                        .padding(.vertical, 14)
                        .frame(width: 361, height: 44, alignment: .center)
                        .background(.my6FB56F)
                        .cornerRadius(10)
                    })
                    .padding(.top, 18)
                }
            }
            if (isQuestionMarkClicked) {
                Group {
                    Image("Stat_Polygon")
                        .padding(.top, -8)
                        .padding(.trailing, 4)
                    Rectangle()
                        .frame(width: 220, height: 178)
                        .foregroundStyle(.my897C6E)
                        .cornerRadius(8)
                        .overlay {
                            VStack(alignment: .leading, spacing: 0) {
                                HStack {
                                    Text("클로버 획득 방법")
                                        .font(.Pretendard.Bold.size13)
                                        .foregroundStyle(.white)
                                    Spacer()
                                    Button(action: {
                                        isQuestionMarkClicked = false
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .resizable()
                                            .frame(width: 10, height: 10)
                                            .foregroundStyle(.white)
                                    })
                                }
                                .padding(.top, 8)
                                .padding(.trailing, 14)
                                HStack {
                                    Image("Clover_Green")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                    Text("초록 클로버")
                                        .font(.Pretendard.SemiBold.size14)
                                        .foregroundStyle(.white)
                                }
                                .padding(.top, 14)
                                Text("하나의 루틴이라도 계획대로\n완수하면 받을 수 있어요")
                                    .font(.Pretendard.Regular.size14)
                                    .foregroundStyle(.white)
                                    .padding(.top, 4)
                                HStack {
                                    Image("Clover_Gold")
                                        .resizable()
                                        .frame(width: 12, height: 12)
                                    Text("황금 클로버")
                                        .font(.Pretendard.SemiBold.size14)
                                        .foregroundStyle(.white)
                                }
                                .padding(.top, 10)
                                Text("모든 루틴을 계획대로 완수하면\n받을 수 있어요")
                                    .font(.Pretendard.Regular.size14)
                                    .foregroundStyle(.white)
                                    .padding(.top, 4)
                            }
                            .padding(.leading, 12)
                            .padding(.bottom, 16)
                        }
                }
                .padding(.top, 30)
            }
        }
    }
}

#Preview {
    StatisticView(isTabBarMainVisible: .constant(true))
}

