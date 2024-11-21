//
//  AllRoutineView.swift
//  OneByte
//
//  Created by 이상도 on 11/19/24.
//

import SwiftUI
import SwiftData

struct AllRoutineView: View {
    
    @Namespace private var animation
    @Query var mainGoals: [MainGoal]
    @State var viewModel = AllRoutineViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            SubgoalTabView() // 전체루틴 상단 Subgoal 탭
            
            // 모든 루틴 전부(.all) 보는 탭
            if viewModel.selectedPicker == .all {
                if let mainGoal = mainGoals.first {
                    ScrollView {
                        VStack(spacing: 16) {
                            // ViewModel에서 SubGoal 필터링 및 정렬
                            ForEach(viewModel.filteredSubGoals(from: mainGoal), id: \.id) { subGoal in
                                VStack(alignment: .leading, spacing: 13) {
                                    HStack {
                                        Image(viewModel.colorClover(for: subGoal.id))
                                            .resizable()
                                            .frame(width: 29, height: 29)
                                            .clipShape(Circle())
                                        
                                        Text(subGoal.title.isEmpty ? "서브목표가 비어있어요." : subGoal.title)
                                            .font(.Pretendard.Bold.size22)
                                            .foregroundStyle(Color.my2B2B2B)
                                        Spacer()
                                    }
                                    
                                    // ViewModel에서 DetailGoal 필터링
                                    ForEach(viewModel.filteredDetailGoals(from: subGoal), id: \.id) { detailGoal in
                                        WeekAchieveCell(detailGoal: detailGoal)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            } else { // 모든 루틴(.all)보는게 아닐경우, 각 탭마다 Subgoal ID를 찾아서 View
                if let mainGoal = mainGoals.first,
                   let selectedSubGoal = viewModel.selectedSubGoal(for: mainGoal) {
                    // SubGoal, DetailGoal 둘다 비어있는 탭이면
                    if viewModel.isSubGoalEmpty(selectedSubGoal) {
                        VStack(spacing: 5) {
                            Image("Turtle_Empty")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 101, height: 149)
                                .padding(.top, 45)
                            Text("아직 루틴이 없어요!")
                                .font(.Pretendard.SemiBold.size18)
                                .padding(.top)
                            Text("만다라트에서 루틴을 추가해보세요.")
                                .font(.Pretendard.Regular.size16)
                                .foregroundStyle(Color.my878787)
                        }
                    } else {
                        // 루틴이 있을시, 전체루틴 Cell을 보여줌
                        WeekRoutineView(tapType: viewModel.selectedPicker, subGoal: selectedSubGoal)
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
                    Image(viewModel.selectedPicker == item ? item.colorClover : item.grayClover)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity / 5)
                        .frame(height: 55)
                }
                .onTapGesture {
                    viewModel.allRoutineTapPicker(to: item)
                }
            }
        }
        .padding(.vertical, 25)
        .padding(5)
    }
}

struct WeekRoutineView : View {
    
    var tapType : tapInfo
    var subGoal: SubGoal
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView(.vertical, showsIndicators: false) {
                HStack {
                    Image(tapType.colorClover)
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
                        WeekAchieveCell(detailGoal: detailGoal)
                        .onTapGesture {
                            print("❌[DEBUG] title : \(detailGoal.title) 데이터 출력")
                            print("❌[DEBUG] id : \(detailGoal.id)")
                            print("❌[DEBUG] memo : \(detailGoal.memo)")
                            print("❌[DEBUG] achieveCount : \(detailGoal.achieveCount)")
                            print("❌[DEBUG] achieveGoal : \(detailGoal.achieveGoal)")
                            print("❌[DEBUG] alertDays : \(detailGoal.alertMon), \(detailGoal.alertTue), \(detailGoal.alertWed), \(detailGoal.alertThu), \(detailGoal.alertFri), \(detailGoal.alertSat), \(detailGoal.alertSun)")
                            print("❌[DEBUG] achieveDays : \(detailGoal.achieveMon), \(detailGoal.achieveTue), \(detailGoal.achieveWed), \(detailGoal.achieveThu), \(detailGoal.achieveFri), \(detailGoal.achieveSat), \(detailGoal.achieveSun)")
                            print("❌[DEBUG] 알림설정 : \(detailGoal.isRemind ? "설정됨" : "설정 안됨")")
                            if let time = detailGoal.remindTime {
                                print("❌[DEBUG] 알림시간 : \(time)")
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

struct WeekAchieveCell: View {
    
    let detailGoal: DetailGoal
    let days: [String] = ["월","화","수","목","금","토","일"]

    var body: some View {
        VStack(spacing: 15) {
            VStack(spacing: 5) {
                HStack {
                    Text(detailGoal.title)
                        .font(.Pretendard.Bold.size16)
                        .foregroundStyle(Color.my2B2B2B)

                    Spacer()

                    Text("달성한 횟수 \(detailGoal.achieveCount)/\(detailGoal.achieveGoal)개")
                        .font(.Pretendard.Medium.size12)
                        .foregroundStyle(Color.my727272)
                }
                HStack {
                    if let remindTime = detailGoal.remindTime {
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
                            .foregroundStyle(Date().currentDay == days[index] ? .white : isAlertActive(for: index) ? Color.my7D7D7D : Color.myDBDBDC)
                            .background(Date().currentDay == days[index] ? Color.my6FB56F : .clear)
                            .clipShape(Circle())

                        ZStack {
                            if isAlertActive(for: index) {
                                if Date().currentDay == days[index] {
                                    // 루틴이고 오늘인데 아직 성취 안했으면 흰색배경, 성취까지 했으면 해당 클로버 이미지
                                    Image(isAchieved(for: index) ? "AchieveClover\(detailGoal.achieveCount + (7 - detailGoal.achieveGoal))" : "RoutineDay")
                                        .resizable()
                                        .scaledToFit()
                                } else if isFutureDay(index: index) {
                                    Image("RoutineNotYet")  // 루틴이긴한데 아직 오지 않은 요일은 회색 배경
                                        .resizable()
                                        .scaledToFit()
                                } else {
                                    if isAchieved(for: index) { // 성취 판단
                                        Image("AchieveClover1")  // 성취한 경우
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

    // alert 요일중 True, False 확인하여 UI
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

    // alert가 true긴하지만, 아직 해당요일이 안됐을때 확인
    private func isFutureDay(index: Int) -> Bool {
        let todayIndex = Date().mondayBasedIndex()
        return index > todayIndex
    }

    // 요일별 Achieve 상태에 따라 UI
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
}

//struct WeekAchieveCell_Previews: PreviewProvider {
//    static var previews: some View {
//        WeekAchieveCell(detailGoal: DetailGoal(id: Int, title: String, memo: String, achieveCount: Int, achieveGoal: Int, alertMon: Bool, alertTue: Bool, alertWed: Bool, alertThu: Bool, alertFri: Bool, alertSat: Bool, alertSun: Bool, isRemind: Bool, remindTime: Date?, achieveMon: Bool, achieveTue: Bool, achieveWed: Bool, achieveThu: Bool, achieveFri: Bool, achieveSat: Bool, achieveSun: Bool))
//        .previewLayout(.sizeThatFits) // 크기 조정
//        .padding()
//    }
//}
