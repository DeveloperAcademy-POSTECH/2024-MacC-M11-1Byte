//
//  WeekAchieveCell.swift
//  OneByte
//
//  Created by 이상도 on 11/28/24.
//

import SwiftUI
import SwiftData

struct WeekAchieveCell: View {
    
    @State var viewModel = AllRoutineViewModel()
    let detailGoal: DetailGoal
    
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 4) {
                HStack {
                    Text(detailGoal.title)
                        .font(.setPretendard(weight: .bold, size: 16))
                        .foregroundStyle(.my2B2B2B)
                    
                    Spacer()
                    
                    Text("달성한 횟수 \(detailGoal.achieveCount)/\(detailGoal.achieveGoal)개")
                        .font(.setPretendard(weight: .medium, size: 12))
                        .foregroundStyle(.my727272)
                }
                HStack {
                    Text(detailGoal.remindTime?.alertTimeString ?? "")
                        .font(.setPretendard(weight: .medium, size: 12))
                        .foregroundStyle(.my727272)
                    
                    Spacer()
                }
            }
            .padding(.top)
            
            HStack {
                let cumulativeAchieveCounts = viewModel.calculateCumulativeAchieveCounts(for: detailGoal)
                ForEach(0..<viewModel.days.count, id: \.self) { index in
                    VStack(spacing: 4) {
                        Text(viewModel.days[index])
                            .font(.setPretendard(weight: .medium, size: 11))
                            .foregroundStyle(.my7D7D7D)
                            .frame(width: 18, height: 18)
                            .clipShape(Circle())
                        
                        ZStack {
                            if viewModel.isAlertActive(for: detailGoal, at: index) {
                                if Date().currentDay == viewModel.days[index] {
                                    // 루틴이고 오늘인데
                                    if viewModel.isAchieved(for: detailGoal, at: index) {
                                        viewModel.setGradationClover(for: detailGoal.achieveGoal, achieveCount: detailGoal.achieveCount)
                                            .resizable()
                                            .scaledToFit()
                                    } else {
                                        Image("RoutineDay")
                                            .resizable()
                                            .scaledToFit()
                                    }
                                } else if viewModel.isFutureDay(index: index) {
                                    Image("RoutineNotYet")  // 루틴이긴한데 아직 오지 않은 요일은 회색 배경
                                        .resizable()
                                        .scaledToFit()
                                } else {
                                    if viewModel.isAchieved(for: detailGoal, at: index) {
                                        viewModel.setGradationClover(for: detailGoal.achieveGoal, achieveCount: cumulativeAchieveCounts[index])
                                            .resizable()
                                            .scaledToFit()
                                    } else {
                                        Image("NoAchieve") // 미성취한 경우
                                            .resizable()
                                            .scaledToFit()
                                    }
                                }
                            } else {
                                Image("NoRoutineDay") // 루틴이 없는 날
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 18)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 18.5)
        .background(.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.myF0E8DF, lineWidth: 1)
        )
    }
}
