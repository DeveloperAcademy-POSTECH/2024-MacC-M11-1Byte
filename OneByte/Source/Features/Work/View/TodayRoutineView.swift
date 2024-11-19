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
            VStack(spacing: 16) {
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
                    
                    ForEach(viewModel.afternoonGoals(from: todayGoals), id: \.id) { detailGoal in
                        TodayRoutineCell(detailGoal: detailGoal)
                    }
                }
                
                // 자유 루틴 섹션
                if !viewModel.freeGoals(from: todayGoals).isEmpty {
                    TodayRoutineTypeHeaderView(routineimage: "star.fill", routineTimeType: "자유 루틴")
                    
                    ForEach(viewModel.freeGoals(from: todayGoals), id: \.id) { detailGoal in
                        TodayRoutineCell(detailGoal: detailGoal)
                    }
                }
            }
            .padding(.horizontal)
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
            } else {
                Text("")
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(detailGoal.title)
                    .font(.Pretendard.SemiBold.size16)
                    .foregroundStyle(Color.my2B2B2B)
                
                Text(detailGoal.memo)
                    .font(.Pretendard.SemiBold.size12)
                    .foregroundStyle(Color.my428142)
            }
            Spacer()
            
            Button {
                print("클로버 버튼 탭")
            } label: {
                Rectangle()
            }
            .frame(width: 32, height: 32)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color(hex: "385E38"), lineWidth: 3)
            )
            .cornerRadius(8)
        }
        .frame(height: 69)
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color(hex: "F0E8DF"), lineWidth: 1)
        )
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

struct TodayRoutineCell_Previews: PreviewProvider {
    static var previews: some View {
        // 더미 데이터 생성
        let sampleDetailGoal = DetailGoal(
            id: 1,
            title: "매일아침 유산균 먹기",
            memo: "건강한 내가 되기",
            achieveCount: 3,
            achieveGoal: 5,
            alertMon: true,
            alertTue: false,
            alertWed: false,
            alertThu: false,
            alertFri: false,
            alertSat: false,
            alertSun: false,
            isRemind: true,
            remindTime: Date(),
            achieveMon: true,
            achieveTue: false,
            achieveWed: false,
            achieveThu: false,
            achieveFri: false,
            achieveSat: false,
            achieveSun: false
        )
        
        // 프리뷰 렌더링
        TodayRoutineCell(detailGoal: sampleDetailGoal)
            .previewLayout(.sizeThatFits) // 적절한 크기 조정
            .padding() // 여백 추가
            .background(Color.myFFFAF4) // 배경색 설정
    }
}
