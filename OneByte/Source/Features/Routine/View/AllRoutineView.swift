//
//  AllRoutineView.swift
//  OneByte
//
//  Created by 이상도 on 11/19/24.
//

import SwiftUI
import SwiftData

struct AllRoutineView: View {
    
    @Namespace private var animation
    @Query var mainGoals: [MainGoal]
    @State var viewModel = AllRoutineViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            SubgoalTabView() // 전체루틴 상단 Subgoal 탭
            
            // 모든 루틴 전부(.all) 보는 탭
            if viewModel.selectedPicker == .all {
                if let mainGoal = mainGoals.first {
                    ScrollView {
                        VStack(spacing: 28) {
                            // ViewModel에서 SubGoal 필터링 및 정렬
                            ForEach(viewModel.filteredSubGoals(from: mainGoal), id: \.id) { subGoal in
                                VStack(alignment: .leading, spacing: 10) {
                                    HStack {
                                        Image(viewModel.colorClover(for: subGoal.id))
                                            .resizable()
                                            .frame(width: 29, height: 29)
                                            .clipShape(Circle())
                                        
                                        Text(subGoal.title.isEmpty ? "서브목표가 비어있어요." : subGoal.title)
                                            .font(.Pretendard.Bold.size18)
                                            .foregroundStyle(Color.my2B2B2B)
                                        Spacer()
                                    }
                                    
                                    // ViewModel에서 DetailGoal 필터링
                                    ForEach(viewModel.filteredDetailGoals(from: subGoal), id: \.id) { detailGoal in
                                        WeekAchieveCell(detailGoal: detailGoal)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.bottom, 32)
                    }
                }
            } else { // 모든 루틴(.all)보는게 아닐경우, 각 탭마다 Subgoal ID를 찾아서 View
                if let mainGoal = mainGoals.first,
                   let selectedSubGoal = viewModel.selectedSubGoal(for: mainGoal) {
                    // SubGoal, DetailGoal 둘다 비어있는 탭이면
                    if viewModel.isSubGoalEmpty(selectedSubGoal) {
                        VStack(spacing: 5) {
                            Image("Turtle_Empty")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 101, height: 133)
                                .padding(.top, 45)
                            Text("아직 루틴이 없어요!")
                                .font(.Pretendard.SemiBold.size18)
                                .padding(.top)
                            Text("만다라트에서 루틴을 추가해보세요.")
                                .font(.Pretendard.Regular.size16)
                                .foregroundStyle(Color.my878787)
                        }
                    } else {
                        // 루틴이 있을시, 전체루틴 Cell을 보여줌
                        WeekRoutineView(tapType: viewModel.selectedPicker, subGoal: selectedSubGoal)
                    }
                }
            }
        }
        .background(Color.myFFFAF4)
    }
    
    @ViewBuilder
    private func SubgoalTabView() -> some View {
        HStack(spacing: 0) {
            ForEach(tapInfo.allCases, id: \.self) { item in
                VStack {
                    Image(viewModel.selectedPicker == item ? item.colorClover : item.grayClover)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity / 5)
                        .frame(height: 55)
                    Text(viewModel.tabTitle(for: item, mainGoals: mainGoals))
                        .font(.Pretendard.SemiBold.size12)
                }
                .onTapGesture {
                    viewModel.allRoutineTapPicker(to: item)
                    viewModel.triggerHaptic()
                }
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 24)
    }
}

struct WeekRoutineView : View {
    
    @State private var isInfoVisible: Bool = false // 팝업 표시 상태
    
    var tapType : tapInfo
    var subGoal: SubGoal
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    HStack {
                        Image(tapType.colorClover)
                            .resizable()
                            .frame(width: 29, height: 29)
                            .clipShape(Circle())
                        
                        Text(subGoal.title == "" ? "서브목표가 비어있어요." : subGoal.title)
                            .font(.Pretendard.Bold.size18)
                            .foregroundStyle(Color.my2B2B2B)
                        Spacer()
                        Image(systemName: "questionmark.circle")
                            .bold()
                            .foregroundStyle(.myB4A99D)
                            .frame(width:20, height: 20)
                            .onTapGesture {
                                isInfoVisible = true
                            }
                    }
                    .padding(.horizontal)
                    
                    VStack(spacing: 10) { // cell 사이 간격
                        // 빈 제목이 아닌 DetailGoal만 표시
                        ForEach(subGoal.detailGoals.filter { !$0.title.isEmpty }, id: \.id) { detailGoal in
                            WeekAchieveCell(detailGoal: detailGoal)
                                .onTapGesture {
                                    print("❌[DEBUG] title : \(detailGoal.title) 데이터 출력")
                                    print("❌[DEBUG] id : \(detailGoal.id)")
                                    print("❌[DEBUG] memo : \(detailGoal.memo)")
                                    print("❌[DEBUG] achieveCount : \(detailGoal.achieveCount)")
                                    print("❌[DEBUG] achieveGoal : \(detailGoal.achieveGoal)")
                                    print("❌[DEBUG] alertDays : \(detailGoal.alertMon), \(detailGoal.alertTue), \(detailGoal.alertWed), \(detailGoal.alertThu), \(detailGoal.alertFri), \(detailGoal.alertSat), \(detailGoal.alertSun)")
                                    print("❌[DEBUG] achieveDays : \(detailGoal.achieveMon), \(detailGoal.achieveTue), \(detailGoal.achieveWed), \(detailGoal.achieveThu), \(detailGoal.achieveFri), \(detailGoal.achieveSat), \(detailGoal.achieveSun)")
                                    print("❌[DEBUG] 알림설정 : \(detailGoal.isRemind ? "설정됨" : "설정 안됨")")
                                    if let time = detailGoal.remindTime {
                                        print("❌[DEBUG] 알림시간 : \(time)")
                                    }
                                }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 16)
                    .padding(.bottom, 32)
                }
            }
            .frame(maxWidth: .infinity)
            
            if isInfoVisible {
                Image("CloverPopup")
                    .resizable()
                    .frame(width: 162, height: 198)
                    .scaledToFit()
                    .transition(.opacity.combined(with: .scale)) // 부드러운 애니메이션
                    .position(x: UIScreen.main.bounds.width - 81, y: 125)
                    .onTapGesture {
                        isInfoVisible = false
                    }
            }
        }
        .onTapGesture {
            isInfoVisible = false
        }
    }
}


