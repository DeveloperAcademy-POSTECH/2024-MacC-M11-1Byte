//
//  AllRoutineView.swift
//  OneByte
//
//  Created by 이상도 on 11/19/24.
//

import SwiftUI
import SwiftData

enum tapInfo : String, CaseIterable {
    
    case all, first, second, third, fourth
    
    var colorClovar: String {
        switch self {
        case .all:
            return "ColorCloverAll"
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
        case.all:
            return "GrayCloverAll"
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

struct AllRoutineView: View {
    
    @State private var selectedPicker: tapInfo = .all
    @Namespace private var animation
    @Query var mainGoals: [MainGoal]
    
    var body: some View {
        VStack(spacing: 0) {
            SubgoalTabView()
            
            // 루틴을 모두(.all) 보는 탭
            if selectedPicker == .all {
                if let mainGoal = mainGoals.first {
                    ScrollView {
                        VStack(spacing: 16) {
                            // subGoals를 id 기준으로 정렬
                            ForEach(mainGoal.subGoals.sorted(by: { $0.id < $1.id }), id: \.id) { subGoal in
                                if !subGoal.title.isEmpty || !subGoal.detailGoals.allSatisfy({ $0.title.isEmpty }) {
                                    VStack(alignment: .leading, spacing: 13) {
                                        HStack {
                                            // subGoal.id에 따라 해당하는 클로버 이미지 적용
                                            Image(colorClovar(for: subGoal.id))
                                                .resizable()
                                                .frame(width: 29, height: 29)
                                                .clipShape(Circle())
                                            
                                            Text(subGoal.title.isEmpty ? "서브목표 없음" : subGoal.title)
                                                .font(.Pretendard.Bold.size22)
                                                .foregroundStyle(Color.my2B2B2B)
                                            Spacer()
                                        }
                                        // DetailGoals를 순서대로 표시
                                        ForEach(subGoal.detailGoals.filter { !$0.title.isEmpty }, id: \.id) { detailGoal in
                                            WeekAchieveCell(
                                                detailGoalTitle: detailGoal.title,
                                                achieveCount: detailGoal.achieveCount,
                                                achieveGoal: detailGoal.achieveGoal,
                                                alertMon: detailGoal.alertMon,
                                                alertTue: detailGoal.alertTue,
                                                alertWed: detailGoal.alertWed,
                                                alertThu: detailGoal.alertThu,
                                                alertFri: detailGoal.alertFri,
                                                alertSat: detailGoal.alertSat,
                                                alertSun: detailGoal.alertSun,
                                                isRemind: detailGoal.isRemind,
                                                remindTime: detailGoal.remindTime,
                                                achieveMon: detailGoal.achieveMon,
                                                achieveTue: detailGoal.achieveTue,
                                                achieveWed: detailGoal.achieveWed,
                                                achieveThu: detailGoal.achieveThu,
                                                achieveFri: detailGoal.achieveFri,
                                                achieveSat: detailGoal.achieveSat,
                                                achieveSun: detailGoal.achieveSat
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal) // cell view side padding
                    }
                }
            }
            else {
                // 각 탭에서 SubGooal과 DetailGoal 2개모두 작성하지 않았을경우
                if let mainGoal = mainGoals.first,
                   let selectedSubGoal = mainGoal.subGoals.first(where: { $0.id == subGoalId(for: selectedPicker) }) {
                    if selectedSubGoal.title.isEmpty && selectedSubGoal.detailGoals.allSatisfy({ $0.title.isEmpty }) {
                        VStack(spacing: 5) {
                            Image("Turtle_5") // ⚠️⚠️⚠️⚠️ 이미지 수정해야함
                                .resizable()
                                .scaledToFit()
                                .frame(width: 101, height: 149)
                            Text("아직 루틴이 없어요!")
                                .font(.Pretendard.SemiBold.size18)
                            Text("만다라트에서 루틴을 추가해보세요.")
                                .font(.Pretendard.SemiBold.size16)
                                .foregroundStyle(Color.my878787)
                        }
                        .padding(.top, 50)
                    } else {  // SubGoal과 DetailGoal중 하나라도 작성된게 있을 경우
                        TodoView(tapType: selectedPicker, subGoal: selectedSubGoal)
                    }
                }
            }
        }
        .background(Color.myFFFAF4)
    }
    
    @ViewBuilder
    private func SubgoalTabView() -> some View {
        HStack(spacing: 0) {
            ForEach(tapInfo.allCases, id: \.self) { item in
                HStack {
                    Image(selectedPicker == item ? item.colorClovar : item.grayClovar)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity / 5)
                        .frame(height: 55)
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedPicker = item
                    }
                }
            }
        }
        .padding(.vertical, 25)
        .padding(5)
    }
    
    private func subGoalId(for tab: tapInfo) -> Int? {
        switch tab {
        case .all: return nil
        case .first: return 1
        case .second: return 2
        case .third: return 3
        case .fourth: return 4
        }
    }
    
    private func colorClovar(for subGoalId: Int) -> String {
        switch subGoalId {
        case 1: return tapInfo.first.colorClovar
        case 2: return tapInfo.second.colorClovar
        case 3: return tapInfo.third.colorClovar
        case 4: return tapInfo.fourth.colorClovar
        default: return tapInfo.all.colorClovar
        }
    }
}

struct TodoView : View {
    
    var tapType : tapInfo
    var subGoal: SubGoal
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    Image(tapType.colorClovar)
                        .resizable()
                        .frame(width: 29, height: 29)
                        .clipShape(Circle())
                    
                    Text(subGoal.title == "" ? "서브목표가 비어있어요." : subGoal.title)
                        .font(.Pretendard.Bold.size22)
                        .foregroundStyle(Color.my2B2B2B)
                    Spacer()
                }
                .padding(.horizontal)
                
                VStack(spacing: 20) {
                    // 빈 제목이 아닌 DetailGoal만 표시
                    ForEach(subGoal.detailGoals.filter { !$0.title.isEmpty }, id: \.id) { detailGoal in
                        WeekAchieveCell(
                            detailGoalTitle: detailGoal.title,
                            achieveCount: detailGoal.achieveCount,
                            achieveGoal: detailGoal.achieveGoal,
                            alertMon: detailGoal.alertMon,
                            alertTue: detailGoal.alertTue,
                            alertWed: detailGoal.alertWed,
                            alertThu: detailGoal.alertThu,
                            alertFri: detailGoal.alertFri,
                            alertSat: detailGoal.alertSat,
                            alertSun: detailGoal.alertSun,
                            isRemind: detailGoal.isRemind,
                            remindTime: detailGoal.remindTime,
                            achieveMon: detailGoal.achieveMon,
                            achieveTue: detailGoal.achieveTue,
                            achieveWed: detailGoal.achieveWed,
                            achieveThu: detailGoal.achieveThu,
                            achieveFri: detailGoal.achieveFri,
                            achieveSat: detailGoal.achieveSat,
                            achieveSun: detailGoal.achieveSat
                        )
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
            .background(Color.myFFFAF4)
        }
        .frame(maxWidth: .infinity)
        .background(Color.myFFFAF4)
    }
}

struct WeekAchieveCell: View {
    
    let detailGoalTitle: String // DetailGoal 제목
    let achieveCount: Int // 현재 달성 횟수
    let achieveGoal: Int // 목표 달성 횟수
    let alertMon: Bool
    let alertTue: Bool
    let alertWed: Bool
    let alertThu: Bool
    let alertFri: Bool
    let alertSat: Bool
    let alertSun: Bool
    let isRemind: Bool
    let remindTime: Date?
    var achieveMon: Bool
    var achieveTue: Bool
    var achieveWed: Bool
    var achieveThu: Bool
    var achieveFri: Bool
    var achieveSat: Bool
    var achieveSun: Bool
    
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
                    
                    Text("달성한 횟수 \(achieveCount)/\(achieveGoal)개")
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
                            .frame(width: 18, height: 18)
                            .foregroundStyle(currentDay == days[index] ? .white : Color.my7D7D7D)
                            .background(currentDay == days[index] ? Color.my6FB56F : .clear)
                            .clipShape(Circle())
                        
                        Button {
                            print("클로버 버튼 탭")
                        } label: {
                            Rectangle()
                        }
                        .frame(maxWidth: .infinity/7, minHeight: 41) // ⚠️⚠️ 나중에 높이 수정
                        .foregroundColor(currentDay == days[index] ? .white : Color.myDBDBDC)
                        .overlay(currentDay == days[index] ? RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "DBDBDC"), lineWidth: 3) : nil)
                        .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 120) // ⚠️⚠️⚠️⚠️⚠️ 프리뷰용 높이 ⚠️⚠️⚠️⚠️⚠️
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.myF0E8DF, lineWidth: 1)
        )
    }
}

//#Preview {
//    AllRoutineView()
//}

struct WeekAchieveCell_Previews: PreviewProvider {
    static var previews: some View {
        WeekAchieveCell(
            detailGoalTitle: "운동하기",
            achieveCount: 3,
            achieveGoal: 5,
            alertMon: true,
            alertTue: false,
            alertWed: true,
            alertThu: false,
            alertFri: true,
            alertSat: false,
            alertSun: false,
            isRemind: true,
            remindTime: Date(),
            achieveMon: true,
            achieveTue: false,
            achieveWed: true,
            achieveThu: false,
            achieveFri: true,
            achieveSat: false,
            achieveSun: false
        )
        .previewLayout(.sizeThatFits) // 크기 조정
        .padding()
    }
}
