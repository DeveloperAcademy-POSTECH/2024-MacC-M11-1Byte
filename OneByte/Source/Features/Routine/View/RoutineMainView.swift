//
//  WorkView.swift
//  OneByte
//
//  Created by 트루디 on 10/17/24.
//

import SwiftUI
import SwiftData

// MARK: 루틴 메인 뷰
struct RoutineMainView: View {
    
    @State var viewModel = RoutineMainViewModel(routineType: .today)
    @Namespace private var animation
    @Query var mainGoals: [MainGoal]
    @Query var clovers: [Clover]
    @Binding var isTabBarMainVisible: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.my6FB56F
                    .ignoresSafeArea(edges: .top)
                
                VStack(spacing: 0) {
                    headerView() // 헤더 뷰
                    
                    motivationMessageView() // 만북이 메세지 뷰
                        .padding(.top, 10)
                    
                    VStack(spacing: 0) {
                        animate() // Tabbar Picker
                        Divider()
                            .foregroundStyle(Color.myF0E8DF)
                        
                        ScrollView(.vertical, showsIndicators: false) { // Picker에 따른 2개 뷰
                            switch viewModel.selectedPicker {
                            case .today:
                                TodayRoutineView() // 오늘의 루틴 탭
                            case .all:
                                AllRoutineView() // 전체 루틴 탭
                            }
                        }
                    }
                    .background(Color.myFFFAF4)
                    .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
                }
            }
            .onAppear {
                isTabBarMainVisible = true
            }
        }
    }
    
    // MARK: 헤더 뷰
    private func headerView() -> some View {
        HStack {
            HStack(alignment: .bottom) {
                Text("\(Date().currentDateString)")
                    .font(.Pretendard.Bold.size22)
                    .foregroundStyle(.white)
                
                Text(viewModel.getTodayWeekofMonth())
                    .font(.Pretendard.SemiBold.size14)
                    .foregroundStyle(Color.myB0E4B0)
            }
            Spacer()
            
            NavigationLink {
                SettingView(isTabBarMainVisible: $isTabBarMainVisible)
            } label: {
                Image("Setting")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(Color.myCEEDCE)
            }
        }
        .padding(.vertical, 8)
        .padding(.leading, 20)
        .padding(.trailing, 24)
    }
    
    // MARK: 동기부여 메시지 뷰
    private func motivationMessageView() -> some View {
        HStack(spacing: 0) {
            TurtleMessageView(message: viewModel.currentMessage)
                .padding(.bottom, 30)
            
            Image("Turtle_Main")
                .resizable()
                .scaledToFit()
                .frame(width: 105, height: 85)
                .onTapGesture {
                    viewModel.updateRandomMessage()
//                    if clovers.isEmpty {
//                        print("⚠️ Clover 데이터가 비어 있습니다.")
//                    } else {
//                        let sortedClovers = clovers.sorted(by: { $0.id < $1.id }) // ID 기준으로 정렬
//                        for clover in sortedClovers {
//                            print("🍀 ID: \(clover.id), Year: \(clover.cloverYear), Month: \(clover.cloverMonth), WeekOfMonth: \(clover.cloverWeekOfMonth), WeekOfYear: \(clover.cloverWeekOfYear), CloverState: \(clover.cloverState)")
//                        }
//                    }
                }
        }
        .padding(.leading, 16)
        .padding(.trailing, 13)
        .padding(.top, 28)
        .padding(.bottom, 8)
    }
    
    // MARK: Tabbar Picker 뷰
    @ViewBuilder
    private func animate() -> some View {
        HStack {
            ForEach(routineTapInfo.allCases, id: \.self) { item in
                VStack {
                    Text(item.rawValue)
                        .font(.Pretendard.Bold.size17)
                        .frame(maxWidth: .infinity/4, minHeight: 50)
                        .foregroundStyle(viewModel.selectedPicker == item ? Color.my1D1D1D : .gray)
                    
                    if viewModel.selectedPicker == item {
                        Capsule()
                            .foregroundStyle(Color.my95D895)
                            .frame(height: 2)
                            .padding(.horizontal, 40)
                            .matchedGeometryEffect(id: "info", in: animation)
                    }
                }
                .onTapGesture {
                    viewModel.routinePicker(to: item)
                }
            }
        }
    }
}


#Preview {
    RoutineMainView(isTabBarMainVisible: .constant(true))
}
