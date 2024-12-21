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
    @Binding var isInfoVisible: Bool
    
    var body: some View {
        ZStack {
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
                                                .font(.setPretendard(weight: .bold, size: 18))
                                                .foregroundStyle(.my2B2B2B)
                                            Spacer()
                                            Image(systemName: "questionmark.circle")
                                                .foregroundStyle(.myB4A99D)
                                                .frame(width:20, height: 20)
                                                .padding(.trailing, 4) // WeekRoutineView의 questionmark와 위치를 맞춤
                                                .onTapGesture {
                                                    isInfoVisible.toggle()
                                                }
                                        }
                                        
                                        // ViewModel에서 DetailGoal 필터링
                                        ForEach(viewModel.filteredDetailGoals(from: subGoal), id: \.id) { detailGoal in
                                            WeekAchieveCell(detailGoal: detailGoal)
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
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
                                    .font(.setPretendard(weight: .semiBold, size: 18))
                                    .padding(.top)
                                Text("나의 목표에서 루틴을 추가해보세요.")
                                    .font(.setPretendard(weight: .regular, size: 16))
                                    .foregroundStyle(.my878787)
                            }
                        } else {
                            // 루틴이 있을시, 전체루틴 Cell을 보여줌
                            WeekRoutineView(isInfoVisible: $isInfoVisible, tapType: viewModel.selectedPicker, subGoal: selectedSubGoal)
                        }
                    }
                }
            }
            .background(.myFFFAF4)
            
            if isInfoVisible {
                RoutinePopUpView(isInfoVisible: $isInfoVisible)
                    .padding(.top, 152)
            }
        }
        .onTapGesture {
            isInfoVisible = false
        }
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
                        .font(.setPretendard(weight: .semiBold, size: 12))
                }
                .onTapGesture {
                    viewModel.allRoutineTapPicker(to: item)
                    viewModel.triggerHaptic()
                    isInfoVisible = false // PopUp 켜진채로 다른 목표 탭 이동시 off
                }
            }
        }
        .padding(.top, 20)
        .padding(.bottom, 28)
        .padding(.horizontal, 10)
    }
}
