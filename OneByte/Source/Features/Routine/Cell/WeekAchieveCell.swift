//
//  WeekAchieveCell.swift
//  OneByte
//
//  Created by 이상도 on 11/28/24.
//

import SwiftUI
import SwiftData

struct WeekAchieveCell: View {
    
    let detailGoal: DetailGoal
    let days: [String] = ["월","화","수","목","금","토","일"]
    
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 4) {
                HStack {
                    Text(detailGoal.title)
                        .font(.Pretendard.Bold.size16)
                        .foregroundStyle(.my2B2B2B)
                    
                    Spacer()
                    
                    Text("달성한 횟수 \(detailGoal.achieveCount)/\(detailGoal.achieveGoal)개")
                        .font(.Pretendard.Medium.size12)
                        .foregroundStyle(.my727272)
                }
                HStack {
                    Text(detailGoal.remindTime?.alertTimeString ?? "")
                        .font(.Pretendard.Medium.size12)
                        .foregroundStyle(.my727272)

                    Spacer()
                }
            }
            .padding(.top)
            
            HStack {
                let cumulativeAchieveCounts = calculateCumulativeAchieveCounts()
                ForEach(0..<days.count, id: \.self) { index in
                    VStack(spacing: 4) {
                        Text(days[index])
                            .font(.Pretendard.Medium.size11)
                            .foregroundStyle(.my7D7D7D)
                            .frame(width: 18, height: 18)
                            .clipShape(Circle())
                        
                        ZStack {
                            if isAlertActive(for: index) {
                                if Date().currentDay == days[index] {
                                    // 루틴이고 오늘인데
                                    if isAchieved(for: index) {
                                        cloverImage(for: detailGoal.achieveGoal, achieveCount: detailGoal.achieveCount)
                                            .resizable()
                                            .scaledToFit()
                                    } else {
                                        Image("RoutineDay")
                                            .resizable()
                                            .scaledToFit()
                                    }
                                } else if isFutureDay(index: index) {
                                    Image("RoutineNotYet")  // 루틴이긴한데 아직 오지 않은 요일은 회색 배경
                                        .resizable()
                                        .scaledToFit()
                                } else {
                                    if isAchieved(for: index) {
                                        cloverImage(for: detailGoal.achieveGoal, achieveCount: cumulativeAchieveCounts[index])
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
    
    // alert 요일 확인
    private func isAlertActive(for index: Int) -> Bool {
        switch index {
        case 0: return detailGoal.alertMon
        case 1: return detailGoal.alertTue
        case 2: return detailGoal.alertWed
        case 3: return detailGoal.alertThu
        case 4: return detailGoal.alertFri
        case 5: return detailGoal.alertSat
        case 6: return detailGoal.alertSun
        default: return false
        }
    }
    
    // 미래 요일인지 확인
    private func isFutureDay(index: Int) -> Bool {
        let todayIndex = Date().mondayBasedIndex()
        return index > todayIndex
    }
    
    // 요일별 성취 상태 확인
    private func isAchieved(for index: Int) -> Bool {
        switch index {
        case 0: return detailGoal.achieveMon
        case 1: return detailGoal.achieveTue
        case 2: return detailGoal.achieveWed
        case 3: return detailGoal.achieveThu
        case 4: return detailGoal.achieveFri
        case 5: return detailGoal.achieveSat
        case 6: return detailGoal.achieveSun
        default: return false
        }
    }
    
    // 클로버 이미지 생성
    private func cloverImage(for achieveGoal: Int, achieveCount: Int) -> Image {
        // 주당 목표 횟수는 1 ~ 7로 가정
        guard achieveGoal >= 1 && achieveGoal <= 7 else {
            return Image("DefaultClover") // 기본 이미지 반환
        }
        // 달성 횟수는 목표 횟수(achieveGoal)를 초과하지 않도록 제한
        let validAchieveCount = max(1, min(achieveCount, achieveGoal)) // 최소값 1로 보정
        
        // 클로버 이미지 이름 생성 및 반환
        let cloverImageName = "Day\(achieveGoal)_Clover\(validAchieveCount)"
        return Image(cloverImageName)
    }
    
    // 성취했는데 지난요일들 클로버 종류별로 보여주기 위해 계산
    private func calculateCumulativeAchieveCounts() -> [Int] {
        var counts: [Int] = []
        var cumulativeCount = 0
        
        for index in 0..<days.count {
            if isAchieved(for: index) {
                cumulativeCount += 1
            }
            counts.append(cumulativeCount)
        }
        
        return counts
    }
}
