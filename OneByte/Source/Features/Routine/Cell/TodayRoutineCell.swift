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
    let detailGoal: DetailGoal
    let subGoalTitle: String
    let viewModel: TodayRoutineViewModel
    let modelContext: ModelContext
    let clovers: [Clover]
    
    var body: some View {
        HStack(spacing: 16) {
            if let remindTime = detailGoal.remindTime {
                VStack {
                    Text(remindTime.timeString)
                        .font(.Pretendard.SemiBold.size14)
                        .foregroundStyle(detailGoal.isAchievedToday ? .my727272.opacity(0.6) : Color.my727272)
                    Spacer()
                }
                .padding(.top, 12)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(detailGoal.title)
                    .font(.Pretendard.SemiBold.size16)
                    .foregroundStyle(detailGoal.isAchievedToday ? .my2B2B2B.opacity(0.7) : .my2B2B2B)
                    .strikethrough(detailGoal.isAchievedToday)
                
                Text(subGoalTitle)
                    .font(.Pretendard.Medium.size14)
                    .foregroundStyle(detailGoal.isAchievedToday ? .my428142.opacity(0.7) : .my428142)
                    .foregroundStyle(Color.my428142)
                Spacer()
            }
            .padding(.top, 12)
            Spacer()
            
            Button {
                print("⚠️[DEBUG] 현재 완료 체크하는 id : \(detailGoal.id)")
                print("⚠️[DEBUG] 현재 완료 체크하는 Title : \(detailGoal.title)")
                print("⚠️[DEBUG] 오늘의 루틴 성취 완료 체크 전 : \(detailGoal.isAchievedToday)")
                viewModel.toggleAchievement(for: detailGoal, in: mainGoal, context: modelContext)
                print("⚠️[DEBUG] 오늘의 루틴 성취 완료 체크 후 : \(detailGoal.isAchievedToday)")
                print("⚠️[DEBUG] MainGoal의 CloverState : \(mainGoal.cloverState)")
                viewModel.calculateCurrentWeekAndMonthWeek(mainGoal: mainGoal, clovers: clovers, context: modelContext)
            } label: {
                Image(detailGoal.isAchievedToday ? "Day7_Clover1" : "RoutineCheck")
                    .resizable()
            }
            .frame(width: 32, height: 32)
        }
        .frame(height: 64)
        .padding(.horizontal)
        .background(.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "F0E8DF"), lineWidth: 1)
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
