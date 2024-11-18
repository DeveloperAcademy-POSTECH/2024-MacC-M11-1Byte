//
//  WorkView.swift
//  OneByte
//
//  Created by 트루디 on 10/17/24.
//

import SwiftUI
import SwiftData

enum tapInfo : String, CaseIterable {
    
    case first, second, third, fourth
    
    var colorClovar: String {
        switch self {
        case .first:
            return "ColorClover1"
        case .second:
            return "ColorClover2"
        case .third:
            return "ColorClover3"
        case .fourth:
            return "ColorClover4"
        }
    }
    
    var grayClovar: String {
        switch self {
        case .first:
            return "GrayClover1"
        case .second:
            return "GrayClover2"
        case .third:
            return "GrayClover3"
        case .fourth:
            return "GrayClover4"
        }
    }
}

struct WorkView: View {
    
    @State private var selectedPicker: tapInfo = .first
    @Namespace private var animation
    @Query var mainGoals: [MainGoal]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("할 일")
                    .font(.Pretendard.Bold.size22)
                    .foregroundStyle(Color(hex: "B4A99D"))
                
                Spacer()
                
                NavigationLink {
                    SettingView()
                } label: {
                    Image(systemName: "info.circle")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color(hex: "B4A99D"))
                }
            }
            .padding()
            
            SubgoalTabView()
            
            Divider()
                .foregroundStyle(Color.myF0E8DF)
    
            if let mainGoal = mainGoals.first,
               let selectedSubGoal = mainGoal.subGoals.first(where: { $0.id == subGoalId(for: selectedPicker) }) {
                TodoView(tests: selectedPicker, subGoal: selectedSubGoal)
            } else {
                Text("현재 Subgoal 데이터가 없습니다.")
            }
            Spacer()
        }
        .ignoresSafeArea(edges: .bottom)
    }
    
    @ViewBuilder
    private func SubgoalTabView() -> some View {
        HStack {
            ForEach(tapInfo.allCases, id: \.self) { item in
                VStack(spacing: 0) {
                    Image(selectedPicker == item ? item.colorClovar : item.grayClovar)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity/4)
                        .frame(height: 51)
                        .padding()
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedPicker = item
                    }
                }
            }
        }
    }
    
    // 탭 선택에 따른 SubGoal ID 반환
    private func subGoalId(for tab: tapInfo) -> Int {
        switch tab {
        case .first: return 1
        case .second: return 2
        case .third: return 3
        case .fourth: return 4
        }
    }
}

struct TodoView : View {
    
    var tests : tapInfo
    var subGoal: SubGoal
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    Image(tests.colorClovar)
                        .resizable()
                        .frame(width: 29, height: 29)
                    
                    Text(subGoal.title == "" ? "서브목표가 비어있어요." : subGoal.title)
                        .font(.Pretendard.Bold.size22)
                        .foregroundStyle(Color.my2B2B2B)
                    Spacer()
                }
                .padding([.top, .horizontal])
                
                VStack(spacing: 16) {
                    // 빈 제목이 아닌 DetailGoal만 표시
                    ForEach(subGoal.detailGoals.filter { !$0.title.isEmpty }, id: \.id) { detailGoal in
                        WeekAchieveCell(
                            detailGoalTitle: detailGoal.title,
                            achieveCount: detailGoal.achieveCount,
                            achieveGoal: detailGoal.achieveGoal,
                            achievedDays: [
                                detailGoal.achieveMon,
                                detailGoal.achieveTue,
                                detailGoal.achieveWed,
                                detailGoal.achieveThu,
                                detailGoal.achieveFri,
                                detailGoal.achieveSat,
                                detailGoal.achieveSun
                            ],
                            remindTime: detailGoal.remindTime
                        )
                    }
                }
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.myFFFAF4)
    }
}

struct WeekAchieveCell: View {
    
    let detailGoalTitle: String // DetailGoal 제목
    let achieveCount: Int // 현재 달성 횟수
    let achieveGoal: Int // 목표 달성 횟수
    let achievedDays: [Bool] // 요일 달성 여부
    let remindTime: Date?
    
    let days: [String] = ["월","화","수","목","금","토","일"] // 요일 데이터 - 고정
    
    // 실제 현재 요일 (월, 화, 수, ...)
    private var currentDay: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "E" // 요일만 가져오기
        return formatter.string(from: Date())
    }
    
    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 5) {
                HStack {
                    Text(detailGoalTitle)
                        .font(.Pretendard.Bold.size16)
                        .foregroundStyle(Color.my2B2B2B)
                    
                    Spacer()
                    
                    Text("달성한 횟수 \(achieveCount)/\(achieveGoal)")
                        .font(.Pretendard.Medium.size12)
                        .foregroundStyle(Color.my727272)
                }
                HStack {
                    if let remindTime = remindTime {
                        Text(remindTime.alertTimeString)
                            .font(.Pretendard.Medium.size12)
                            .foregroundStyle(Color.my727272)
                    } else {
                        Text("")
                    }
                    Spacer()
                }
            }
            HStack {
                ForEach(0..<days.count, id: \.self) { index in
                    VStack(spacing: 4) {
                        Text(days[index])
                            .font(.Pretendard.Medium.size11)
                            .foregroundStyle(currentDay == days[index] ? .white : (achievedDays[index] ? Color.myFFFEFC : Color.my7D7D7D))
                            .frame(width: 18, height: 18)
                            .background(currentDay == days[index] ? Color.my385E38 : (achievedDays[index] ? Color.my358E38 : .clear)) // 현재 요일 체크
                            .clipShape(Circle())
                        
                        Button {
                            print("클로버 버튼 탭")
                        } label: {
                            Rectangle()
                        }
                        .frame(maxWidth: .infinity/7, minHeight: 41) // ⚠️⚠️ 나중에 높이 수정
                        .foregroundColor(currentDay == days[index] ? .white : Color.myDBDBDC)
                        .overlay(currentDay == days[index] ? RoundedRectangle(cornerRadius: 8).stroke(Color.my385E38, lineWidth: 3) : nil)
                        .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.myF0E8DF, lineWidth: 1)
        )
    }
}

#Preview {
    WorkView()
}
