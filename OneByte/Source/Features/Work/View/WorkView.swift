//
//  WorkView.swift
//  OneByte
//
//  Created by 트루디 on 10/17/24.
//

import SwiftUI

enum tapInfo : String, CaseIterable {
    
    case first, second, third, fourth
//    case first = "건강" // ⚠️⚠️ Subgoal 1 데이터
//    case second = "학업" // ⚠️⚠️ Subgoal 2 데이터
//    case third = "저축" // ⚠️⚠️ Subgoal 3 데이터
//    case fourth = "여행" // ⚠️⚠️ Subgoal 4 데이터
    
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
    
    var body: some View {
        VStack {
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
            
            animate()
            testView(tests: selectedPicker)
            
            Spacer()
        }
    }
    
    @ViewBuilder
    private func animate() -> some View {
        HStack {
            ForEach(tapInfo.allCases, id: \.self) { item in
                VStack(spacing: 0) {
                    Image(selectedPicker == item ? item.colorClovar : item.grayClovar)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity/4)
                        .frame(height: 51)
                        .padding()
                    
//                    Text(item.rawValue) // ⚠️⚠️ 해당 Subgoal 없으면 ""처리하기
//                        .font(selectedPicker == item ? .Pretendard.Bold.size14 : .Pretendard.Regular.size14)
//                        .frame(maxWidth: .infinity/4, maxHeight: 35)
//                        .foregroundColor(selectedPicker == item ? .black : Color.my8E8E8E)
                    
//                    if selectedPicker == item {
//                        Capsule()
//                            .foregroundColor(.black)
//                            .frame(height: 3)
//                            .matchedGeometryEffect(id: "info", in: animation)
//                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        self.selectedPicker = item
                    }
                }
            }
        }
    }
}

struct testView : View {
    
    var tests : tapInfo
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            switch tests {
            case .first:
                ForEach(0..<5) { _ in
                    Text("블랙컬러")
                        .padding()
                }
            case .second:
                Text("사이즈 참고해주세요")
                    .font(.system(size: 15, weight: .bold, design: .monospaced))
                    .frame(width: 300, height: 20, alignment: .center)
                
            case .third:
                ScrollView(.horizontal, showsIndicators: false) {
                    ForEach(0..<10) { _ in
                        LazyHStack {
                            ForEach(0..<2) { _ in
                                VStack(spacing: 5) {
                                    Image("shoes")
                                        .resizable()
                                        .frame(width: 160, height: 200, alignment: .center)
                                    Text("실착용 솔직 한달 후기 입니다")
                                        .font(.system(size: 15, weight: .bold, design: .monospaced))
                                        .frame(width: 160, height: 20, alignment: .leading)
                                        .foregroundColor(.black)
                                    
                                }
                                .padding(15)
                                
                            }
                        }
                    }
                }
            case .fourth:
                VStack {
                    Text("별도의 커뮤니티를 운영하지 않습니다.")
                }
            }
        }
    }
}

struct WeekAchieveCell: View {
    let detailGoalTitle: String // DetailGoal 제목
    let achieveCount: Int // 현재 달성 횟수
    let achieveGoal: Int // 목표 달성 횟수
    let days: [String] = ["월","화","수","목","금","토","일"] // 요일 데이터 - 고정
    let achievedDays: [Bool] // 요일 달성 여부

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text(detailGoalTitle)
                    .font(.Pretendard.Bold.size16)
                    .foregroundStyle(Color(hex: "2B2B2B"))
                
                Spacer()
                
                Text("달성한 횟수 \(achieveCount)/\(achieveGoal)")
                    .font(.Pretendard.Medium.size12)
                    .foregroundStyle(Color(hex: "7D7D7D"))
            }
            
            HStack {
                ForEach(0..<days.count, id: \.self) { index in
                    VStack(spacing: 4) {
                        Text(days[index])
                            .font(.Pretendard.Medium.size11)
                            .foregroundStyle(achievedDays[index] ? .white : Color(hex: "7D7D7D"))
                            .frame(width: 18, height: 18)
                            .background(achievedDays[index] ? Color(hex: "385E38") : .clear)
                            .clipShape(Circle())
                        
                        Button {
                            // 클로버 버튼 탭
                        } label: {
                            Rectangle()
                        }
                        .frame(maxWidth: .infinity/7, minHeight: 41) // ⚠️⚠️ 나중에 높이 수정
                        .foregroundColor(achievedDays[index] ? Color.green : Color.gray.opacity(0.2))
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
                .stroke(Color(hex: "F0E8DF"), lineWidth: 1)
        )
    }
}

struct ContentView: View {
    let goals = [
        ("헬스장에서 2시간 운동", 0, 7, [true, false, false, false, false, false, false]),
        ("매일 아침 유산균 먹기", 0, 6, [false, false, false, false, false, false, false]),
        ("벤치프레스 기록 갱신", 0, 2, [false, false, false, false, false, false, false])
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                ForEach(goals, id: \.0) { goal in
                    WeekAchieveCell(
                        detailGoalTitle: goal.0,
                        achieveCount: goal.1,
                        achieveGoal: goal.2,
                        achievedDays: goal.3
                    )
                }
            }
            .padding()
        }
        .background(Color(hex: "F9F5F0")
        .ignoresSafeArea())
    }
}


#Preview {
    WorkView()
}
