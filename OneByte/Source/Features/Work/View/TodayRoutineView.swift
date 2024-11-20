//
//  TodayRoutineView.swift
//  OneByte
//
//  Created by 이상도 on 11/19/24.
//

import SwiftUI
import SwiftData

struct TodayRoutineView: View {
    
    @Query var mainGoals: [MainGoal] // 모든 MainGoal 데이터를 쿼리
    @State var viewModel = TodayRoutineViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 15) {
                // 데이터 업데이트
                let todayGoals = viewModel.filterTodayGoals(from: mainGoals)
                
                // 오전 루틴 섹션
                if !viewModel.morningGoals(from: todayGoals).isEmpty {
                    TodayRoutineTypeHeaderView(routineimage: "sun.max.fill", routineTimeType: "오전 루틴")
                    
                    ForEach(viewModel.morningGoals(from: todayGoals), id: \.id) { detailGoal in
                        TodayRoutineCell(detailGoal: detailGoal)
                    }
                }
                
                // 오후 루틴 섹션
                if !viewModel.afternoonGoals(from: todayGoals).isEmpty {
                    TodayRoutineTypeHeaderView(routineimage: "moon.fill", routineTimeType: "오후 루틴")
                        .padding(.top)
                    
                    ForEach(viewModel.afternoonGoals(from: todayGoals), id: \.id) { detailGoal in
                        TodayRoutineCell(detailGoal: detailGoal)
                    }
                }
                
                // 자유 루틴 섹션
                if !viewModel.freeGoals(from: todayGoals).isEmpty {
                    TodayRoutineTypeHeaderView(routineimage: "star.fill", routineTimeType: "자유 루틴")
                        .padding(.top)
                    
                    ForEach(viewModel.freeGoals(from: todayGoals), id: \.id) { detailGoal in
                        TodayRoutineCell(detailGoal: detailGoal)
                    }
                }
            }
            .padding()
        }
        .background(Color.myFFFAF4)
    }
}

struct TodayRoutineCell: View {
    
    let detailGoal: DetailGoal
    
    var body: some View {
        HStack(spacing: 15) {
            // 알림 시간 있으면 표시
            if let remindTime = detailGoal.remindTime {
                Text(remindTime.timeString)
                    .font(.Pretendard.Medium.size14)
                    .foregroundStyle(Color.my727272)
                    .padding(.bottom)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(detailGoal.title)
                    .font(.Pretendard.SemiBold.size16)
                    .foregroundStyle(Color.my2B2B2B)
                    .strikethrough(detailGoal.isAchievedToday)
                
                Text(detailGoal.memo) // ⚠️⚠️⚠️ 나중에 detailGoal에 해당하는 Subgoal title띄워지게  ⚠️⚠️⚠️
                    .font(.Pretendard.SemiBold.size12)
                    .foregroundStyle(Color.my428142)
            }
            Spacer()
            
            Button {
                print("⚠️[DEBUG] 현재 완료 체크하는 id : \(detailGoal.id)")
                print("⚠️[DEBUG] 현재 완료 체크하는 Title : \(detailGoal.title)")
                print("⚠️[DEBUG] 오늘의 루틴 성취 완료 체크 전 : \(detailGoal.isAchievedToday)")
                toggleAchievement()
                print("⚠️[DEBUG] 오늘의 루틴 성취 완료 체크 후 : \(detailGoal.isAchievedToday)")
            } label: {
                Image(detailGoal.isAchievedToday ? "AchieveClover1" : "RoutineCheck")
                    .resizable()
            }
            .frame(width: 32, height: 32)

        }
        .frame(height: 69)
        .padding(.horizontal)
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "F0E8DF"), lineWidth: 1)
        )
    }
    private func toggleAchievement() {
        let todayIndex = Date().mondayBasedIndex() // 월요일 기준 인덱스
            switch todayIndex {
            case 0: detailGoal.achieveMon.toggle()
            case 1: detailGoal.achieveTue.toggle()
            case 2: detailGoal.achieveWed.toggle()
            case 3: detailGoal.achieveThu.toggle()
            case 4: detailGoal.achieveFri.toggle()
            case 5: detailGoal.achieveSat.toggle()
            case 6: detailGoal.achieveSun.toggle()
            default: break
            }
        }
}

extension DetailGoal {
    func isTodayRoutine(for day: String) -> Bool {
        switch day {
        case "월": return alertMon
        case "화": return alertTue
        case "수": return alertWed
        case "목": return alertThu
        case "금": return alertFri
        case "토": return alertSat
        case "일": return alertSun
        default: return false
        }
    }
}

extension Date {
    var hour: Int {
        return Calendar.current.component(.hour, from: self)
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
