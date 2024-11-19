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
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.my6FB56F
                    .ignoresSafeArea(edges: .top)
                
                VStack(spacing: 0) {
                    headerView() // 헤더 뷰
                    
                    motivationMessageView() // 만북이 메세지 뷰
                    
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
        }
    }
    
    // MARK: 헤더 뷰
    private func headerView() -> some View {
        HStack {
            HStack(alignment: .bottom) {
                Text("\(viewModel.mainDateManager.koreanFormattedDate(for: viewModel.todayDate)) (\(Date().currentDay))")
                    .font(.Pretendard.Bold.size22)
                    .foregroundStyle(.white)
                
                Text(viewModel.mainDateManager.koreanMonthAndWeek(for: viewModel.todayDate))
                    .font(.Pretendard.SemiBold.size14)
                    .foregroundStyle(Color.myB0E4B0)
            }
            Spacer()
            
            NavigationLink {
                SettingView()
            } label: {
                Image(systemName: "gear")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.myCEEDCE)
            }
        }
        .padding()
    }
    
    // MARK: 동기부여 메시지 뷰 ⚠️⚠️⚠️⚠️⚠️ 메세지 수정해야함 ⚠️⚠️⚠️⚠️⚠️
    private func motivationMessageView() -> some View {
        HStack {
            Text("완벽하지 않아도 괜찮아요.\n중요한 것은 꾸준히 다시 시작하는 거예요!")
                .font(.Pretendard.Medium.size14)
                .foregroundStyle(Color.my3C3C3C)
            Image("Turtle_Main")
                .resizable()
                .scaledToFit()
                .frame(width: 105, height: 85)
        }
        .padding()
        .background(Color.my6FB56F)
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
    RoutineMainView()
}
