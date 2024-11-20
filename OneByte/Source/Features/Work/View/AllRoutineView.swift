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
            SubgoalTabView()
            
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
                        .padding(.horizontal)
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
                          TodoView(tapType: viewModel.selectedPicker, subGoal: selectedSubGoal)
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

struct TodoView : View {
    
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
//                .frame(maxWidth: .infinity) ❌❌❌❌❌ 지워 ❌❌❌❌❌
                .padding(.horizontal)
            }
//            .background(Color.myFFFAF4) ❌❌❌❌❌ 지워 ❌❌❌❌❌
        }
//        .frame(maxWidth: .infinity) ❌❌❌❌❌ 지워 ❌❌❌❌❌
//        .background(Color.myFFFAF4) ❌❌❌❌❌ 지워 ❌❌❌❌❌
    }
}

struct WeekAchieveCell: View {
    
    let detailGoalTitle: String
    let achieveCount: Int
    let achieveGoal: Int
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
                            .foregroundStyle(Date().currentDay == days[index] ? .white : Color.my7D7D7D)
                            .background(Date().currentDay == days[index] ? Color.my6FB56F : .clear)
                            .clipShape(Circle())
                        
                        Button {
                            print("클로버 버튼 탭")
                        } label: {
                            Rectangle()
                        }
                        .frame(maxWidth: .infinity/7, minHeight: 41) // ⚠️⚠️ 나중에 높이 수정
                        .foregroundStyle(Date().currentDay == days[index] ? .white : Color.myDBDBDC)
                        .overlay(
                            Date().currentDay == days[index] ?
                            RoundedRectangle(cornerRadius: 8).stroke(Color(hex: "DBDBDC"), lineWidth: 2)
                            : nil
                        )
                        .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(maxWidth: .infinity)
        }
        //        .frame(height: 120) // ⚠️⚠️⚠️⚠️⚠️ 프리뷰 볼때 적용하는 높이 ⚠️⚠️⚠️⚠️⚠️
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
