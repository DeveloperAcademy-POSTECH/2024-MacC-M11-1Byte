//
//  WeekRoutineView.swift
//  OneByte
//
//  Created by 이상도 on 12/20/24.
//

import SwiftUI

struct WeekRoutineView : View {
    
    @State var viewModel = AllRoutineViewModel()
    @Binding var isPopUpVisible: Bool
    var tapType : tapInfo
    var subGoal: SubGoal
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    HStack(spacing: 8) {
                        Image(tapType.colorClover)
                            .resizable()
                            .frame(width: 29, height: 29)
                            .clipShape(Circle())
                        
                        Text(subGoal.title == "" ? "서브목표가 비어있어요." : subGoal.title)
                            .font(.setPretendard(weight: .bold, size: 18))
                            .foregroundStyle(.my2B2B2B)
                        Spacer()
                        Image(systemName: "questionmark.circle")
                            .foregroundStyle(.myB4A99D)
                            .frame(width:20, height: 20)
                            .onTapGesture {
                                isPopUpVisible.toggle()
                            }
                    }
                    .padding(.leading, 16)
                    .padding(.trailing, 20)
                    
                    VStack(spacing: 10) { // cell 사이 간격
                        // 빈 제목이 아닌 DetailGoal만 표시
                        ForEach(subGoal.detailGoals.filter { !$0.title.isEmpty }, id: \.id) { detailGoal in
                            WeekAchieveCell(detailGoal: detailGoal)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal)
                    .padding(.bottom, 32)
                }
            }
            .frame(maxWidth: .infinity)
            
            if isPopUpVisible {
                VStack {
                    PopUpView()
                        .padding(.top, 28)
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    private func PopUpView() -> some View {
        VStack(spacing: -5) {
            HStack {
                Spacer()
                Image("Stat_Polygon")
                    .padding(.trailing, 21)
            }
            HStack {
                Spacer()
                Rectangle()
                    .frame(width: 162, height: 190)
                    .foregroundStyle(.my897C6E)
                    .cornerRadius(8)
                    .overlay {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("진행도 상태 표시")
                                    .font(.setPretendard(weight: .bold, size: 13))
                                    .foregroundStyle(.white)
                                Spacer()
                                Button {
                                    isPopUpVisible = false
                                } label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .bold()
                                        .frame(width: 10, height: 10)
                                        .foregroundStyle(.white)
                                }
                            }
                            
                            HStack(spacing: 8) {
                                Image("RoutinePopup1")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                Text("루틴을 완료했어요")
                                    .font(.setPretendard(weight: .semiBold, size: 13))
                                    .foregroundStyle(.white)
                            }
                            .padding(.top, 4)
                            
                            HStack(spacing: 8) {
                                Image("RoutinePopup2")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                Text("루틴을 못했어요")
                                    .font(.setPretendard(weight: .semiBold, size: 13))
                                    .foregroundStyle(.white)
                            }
                            HStack(spacing: 8) {
                                Image("RoutinePopup3")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                Text("루틴을 해야해요")
                                    .font(.setPretendard(weight: .semiBold, size: 13))
                                    .foregroundStyle(.white)
                            }
                            HStack(spacing: 8) {
                                Image("RoutinePopup4")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                Text("루틴이 없어요")
                                    .font(.setPretendard(weight: .semiBold, size: 13))
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(12)
                    }
            }
            .padding(.trailing, 16)
        }
    }
}
