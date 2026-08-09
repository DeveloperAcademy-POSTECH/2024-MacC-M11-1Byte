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

    private var isReadOnlyCarryover: Bool {
        !viewModel.isDateToday(targetDate) && !viewModel.canToggleRoutine(on: targetDate)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            if let remindTime = detailGoal.remindTime {
                VStack {
                    Text(remindTime.timeString)
                        .font(.setPretendard(weight: .semiBold, size: 14))
                        .foregroundStyle(textColor(base: .my727272))
                    Spacer()
                }
                .padding(.top, 12)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(detailGoal.title)
                    .font(.setPretendard(weight: .semiBold, size: 16))
                    .foregroundStyle(textColor(base: .my2B2B2B))
                    .strikethrough(viewModel.isAchieved(detailGoal, on: targetDate))
                    .lineLimit(2)
                
                Text(subGoalTitle)
                    .font(.setPretendard(weight: .medium, size: 14))
                    .foregroundStyle(textColor(base: .my428142))
                    .lineLimit(1)
            }
            .padding(.top, 12)

            if !viewModel.isDateToday(targetDate) {
                Text("어제")
                    .font(.setPretendard(weight: .medium, size: 12))
                    .foregroundStyle(isReadOnlyCarryover ? .myB9B9B9 : .my878787)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(isReadOnlyCarryover ? .myEEEEEE : .myF0E8DF)
                    .clipShape(Capsule())
                    .padding(.top, 12)
            }
            Spacer()
            
            Button {
                viewModel.toggleAchievement(for: detailGoal, in: mainGoal, on: targetDate, context: modelContext)
                viewModel.calculateCurrentWeekAndMonthWeek(mainGoal: mainGoal, clovers: clovers, context: modelContext)
                viewModel.refreshNotificationSchedules(mainGoals: allMainGoals)
                viewModel.syncWidgetSnapshot(mainGoals: allMainGoals)
            } label: {
                Image(viewModel.isAchieved(detailGoal, on: targetDate) ? "Day7_Clover1" : "RoutineCheck")
                    .resizable()
                    .scaledToFit()
            }
            .disabled(!viewModel.canToggleRoutine(on: targetDate))
            .opacity(viewModel.canToggleRoutine(on: targetDate) ? 1 : 0.45)
            .frame(width: 32, height: 32)
            .padding(.top, 12)
        }
        .frame(minHeight: 64, alignment: .top)
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(isReadOnlyCarryover ? Color.myF1F1F1 : .white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isReadOnlyCarryover ? .myE4E4E4 : .myF0E8DF, lineWidth: 1)
        )
    }

    private func textColor(base: Color) -> Color {
        if isReadOnlyCarryover {
            return .my8E8E8E
        }

        if viewModel.isAchieved(detailGoal, on: targetDate) {
            return base.opacity(0.7)
        }

        return base
    }
}

extension DetailGoal {
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
