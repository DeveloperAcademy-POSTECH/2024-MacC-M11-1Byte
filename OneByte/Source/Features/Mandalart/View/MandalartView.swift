//
//  ObjectiveView.swift
//  OneByte
//
//  Created by 트루디 on 11/03/24.
//
import SwiftUI
import SwiftData

struct MandalartView: View {
    @AppStorage("FirstOnboarding") var FirstOnboarding: Bool = true
    @Query private var mainGoals: [MainGoal]
    @State var isPresented = false
    @State private var subGoal: SubGoal?
    @State private var mainGoal: MainGoal?
    
    var body: some View {
        NavigationStack {
            if let firstMainGoal = mainGoals.first {
                OuterGridView(
                    isPresented: $isPresented,
                    subGoal: $subGoal,
                    mainGoal: $mainGoal
                )
                .onAppear {
                    mainGoal = firstMainGoal
                }
            } else {
                Text("MainGoal 데이터를 찾을 수 없습니다.")
                    .foregroundStyle(.gray)
                    .padding()
            }
        }
        .fullScreenCover(isPresented: $FirstOnboarding) {
            OnboardingStartView()
        }
    }
}


// MARK: 첫화면 -  전체 81개짜리
struct OuterGridView: View {
    @Binding var isPresented: Bool
    @Binding var subGoal: SubGoal?
    @Binding var mainGoal: MainGoal? // mainGoal을 @Binding으로 사용
    
    @State var mainIsPresented: Bool = false
    private let outerColumns = Array(repeating: GridItem(.flexible()), count: 3)

    var body: some View {
        VStack(alignment: .leading) {
            // 앱 로고
            Image("appLogo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 22)
                .foregroundStyle(Color.my9E9E9E)
                .padding(.top, 20)
            
            Spacer()
            
            // 다라 & comment
            HStack() {
                Image("Dara5")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 65)
                
                ZStack{
                    Image("comment")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 55)
                    Text("한 걸을씩 가다 보면 \n어느새 큰 변화를 느낄 거예요!")
                        .font(.system(size: 14))
                }
            }
            
            ZStack {
                // 배경색과 모서리 둥글게 처리
                Color.my538F53
                    .cornerRadius(10)
                
                HStack(spacing: 10) {
                    // 좌측 텍스트
                    Text("나의 목표")
                        .foregroundStyle(Color.myD5F3D1)
                        .font(.Pretendard.Medium.size16)
                    
                    // 중간 텍스트
                    Text(mainGoal?.title ?? "목표없음")
                        .foregroundStyle(.white)
                        .font(.Pretendard.Bold.size16)
                    
                    Spacer()
                    
                    // 점 세 개 버튼
                    Button(action: {
                        mainIsPresented = true
                    }) {
                        Image(systemName: "ellipsis")
                            .foregroundColor(.white)
                            .rotationEffect(.degrees(90))
                    }
                    .sheet(isPresented: $mainIsPresented) {
                        MainGoalsheetView(mainGoal: $mainGoal, isPresented: $mainIsPresented)
                            .presentationDragIndicator(.visible)
                            .presentationDetents([.height(244/852 * UIScreen.main.bounds.height)])
                    }
                }
                .padding()
            }
            .frame(height: 43/852 * UIScreen.main.bounds.height)
            .padding(.vertical)
            
            // 만다라트 그리드
            if let selectedMainGoal = mainGoal {
                let sortedSubGoals = selectedMainGoal.subGoals.sorted(by: { $0.id < $1.id }) // 정렬된 SubGoals 배열
                
                LazyVGrid(columns: outerColumns, spacing: 3) {
                    ForEach(0..<9, id: \.self) { index in
                        if index == 4 {
                            MainGoalCell(subGoal: $subGoal, mainGoal: $mainGoal, isPresented: $isPresented)
                        } else {
                            let subGoalIndex = index < 4 ? index : index - 1
                            if subGoalIndex < sortedSubGoals.count {
                                SubGoalCell(isPresented: $isPresented, selectedSubGoal: Binding(
                                    get: { sortedSubGoals[subGoalIndex] },
                                    set: { _ in }
                                ))
                            } else {
                                EmptyView()
                            }
                        }
                    }
                }
            } else {
                Text("찾을 수 없습니다.")
            }
            Spacer()
        }
        .padding(.horizontal, 20/393 * UIScreen.main.bounds.width)
    }
}
