//
//  WorkView.swift
//  OneByte
//
//  Created by 트루디 on 10/17/24.
//

import SwiftUI
import SwiftData
import Lottie

// MARK: 루틴 메인 뷰
struct RoutineMainView: View {
    
    @State var viewModel = RoutineMainViewModel(routineType: .today)
    @Namespace private var animation
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
                            .foregroundStyle(.myF0E8DF)
                        
                        ScrollView(.vertical, showsIndicators: false) { // Picker에 따른 2개 뷰
                            switch viewModel.selectedPicker {
                            case .today:
                                TodayRoutineView() // 오늘의 루틴 탭
                            case .all:
                                AllRoutineView(isPopUpVisible: $viewModel.isPopUpVisible) // 전체 루틴 탭
                            }
                        }
                    }
                    .background(.myFFFAF4)
                    .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
                }
            }
            .onTapGesture {
                viewModel.isPopUpVisible = false
            }
            .onAppear {
                isTabBarMainVisible = true
            }
            .onDisappear {
                viewModel.isPopUpVisible = false // 팝업뷰 on 상태에서 메인탭 이동시에도 dismiss 
            }
        }
    }
    
    // MARK: 헤더 뷰
    private func headerView() -> some View {
        HStack {
            HStack(alignment: .bottom) {
                Text("\(Date().currentDateString)")
                    .font(.setPretendard(weight: .bold, size: 22))
                    .foregroundStyle(.white)
                
                Text(viewModel.getTodayWeekofMonth())
                    .font(.setPretendard(weight: .semiBold, size: 14))
                    .foregroundStyle(.myB0E4B0)
            }
            Spacer()
            
            NavigationLink {
                SettingView(isTabBarMainVisible: $isTabBarMainVisible)
            } label: {
                Image("Setting")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundStyle(.myCEEDCE)
            }
        }
        .padding(.vertical, 8)
        .padding(.leading, 20)
        .padding(.trailing, 24)
    }
    
    // MARK: 동기부여 메시지 뷰
    private func motivationMessageView() -> some View {
        HStack(spacing: 6) {
            Spacer()
            TurtleMessageView(message: viewModel.currentMessage)
                .padding(.bottom, 60)
            
            LottieView(animation: .named("RoutineTurtle"))
                .playing(loopMode: .repeat(2))
                .frame(width: 105, height: 100)
                .onTapGesture {
                    viewModel.updateRandomMessage()
                    viewModel.routineTurtleHaptic()
                }
        }
        .padding(.trailing, 10)
        .padding(.top, 14)
    }
    
    // MARK: Tabbar Picker 뷰
    @ViewBuilder
    private func animate() -> some View {
        HStack {
            ForEach(routineTapInfo.allCases, id: \.self) { item in
                VStack {
                    Text(item.rawValue)
                        .font(.setPretendard(weight: .bold, size: 17))
                        .frame(maxWidth: .infinity/4, minHeight: 50)
                        .foregroundStyle(viewModel.selectedPicker == item ? .my1D1D1D : .gray)
                    
                    if viewModel.selectedPicker == item {
                        Capsule()
                            .foregroundStyle(.my95D895)
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
