//
//  TodayRoutineCell.swift
//  OneByte
//
//  Created by 이상도 on 11/28/24.
//

import SwiftUI
import SwiftData

struct TodayRoutineCell: View {
    
    let mainGoal: MainGoal
    let allMainGoals: [MainGoal]
    let detailGoal: DetailGoal
    let subGoalTitle: String
    let viewModel: TodayRoutineViewModel
    let modelContext: ModelContext
    let clovers: [Clover]
    let targetDate: Date
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if let remindTime = detailGoal.remindTime {
                VStack {
                    Text(remindTime.timeString)
                        .font(.setPretendard(weight: .semiBold, size: 14))
                        .foregroundStyle(viewModel.isAchieved(detailGoal, on: targetDate) ? .my727272.opacity(0.6) : .my727272)
                    Spacer()
                }
                .padding(.top, 12)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(detailGoal.title)
                    .font(.setPretendard(weight: .semiBold, size: 16))
                    .foregroundStyle(viewModel.isAchieved(detailGoal, on: targetDate) ? .my2B2B2B.opacity(0.7) : .my2B2B2B)
                    .strikethrough(viewModel.isAchieved(detailGoal, on: targetDate))
                    .lineLimit(2)
                
                Text(subGoalTitle)
                    .font(.setPretendard(weight: .medium, size: 14))
                    .foregroundStyle(viewModel.isAchieved(detailGoal, on: targetDate) ? .my428142.opacity(0.7) : .my428142)
                    .lineLimit(1)
            }
            .padding(.top, 12)
            
            if !Calendar.current.isDateInToday(targetDate) {
                Text("어제")
                    .font(.setPretendard(weight: .medium, size: 12))
                    .foregroundStyle(.my878787)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.myF7F3EE)
                    .clipShape(Capsule())
                    .padding(.top, 12)
            }
            Spacer()
            
            Button {
                print("⚠️[DEBUG] 현재 완료 체크하는 id : \(detailGoal.id)")
                print("⚠️[DEBUG] 현재 완료 체크하는 Title : \(detailGoal.title)")
                viewModel.toggleAchievement(for: detailGoal, in: mainGoal, on: targetDate, context: modelContext)
                print("⚠️[DEBUG] MainGoal의 CloverState : \(mainGoal.cloverState)")
                viewModel.calculateCurrentWeekAndMonthWeek(mainGoal: mainGoal, clovers: clovers, context: modelContext)
                viewModel.syncWidgetSnapshot(mainGoals: allMainGoals)
            } label: {
                Image(viewModel.isAchieved(detailGoal, on: targetDate) ? "Day7_Clover1" : "RoutineCheck")
                    .resizable()
                    .scaledToFit()
            }
            .frame(width: 32, height: 32)
            .padding(.top, 12)
        }
        .frame(minHeight: 64, alignment: .top)
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.myF0E8DF, lineWidth: 1)
        )
    }
}

extension DetailGoal {
    //  오늘의 루틴 완료 여부를 확인 및 UI 업데이트
    var isAchievedToday: Bool {
        let todayIndex = Date().mondayBasedIndex()
        switch todayIndex {
        case 0: return achieveMon
        case 1: return achieveTue
        case 2: return achieveWed
        case 3: return achieveThu
        case 4: return achieveFri
        case 5: return achieveSat
        case 6: return achieveSun
        default: return false
        }
    }
}
