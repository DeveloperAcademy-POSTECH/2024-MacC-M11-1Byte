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
    private let outerColumns = [GridItem(.adaptive(minimum: 160/852 * UIScreen.main.bounds.height), spacing: 32)]
    private let dateManager = DateManager()
    private let currentDate = Date()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 날짜 및 공유, 설정 버튼
            HStack(alignment: .bottom ,spacing: 8) {
                // 한국 날짜 형식으로 오늘 날짜 표시
                Text(dateManager.koreanFormattedDate(for: currentDate))
                    .font(.Pretendard.Bold.size22)
                    .foregroundStyle(Color.my566956)
                
                // 현재 달의 몇 주차인지 표시
                Text(dateManager.koreanMonthAndWeek(for: currentDate))
                    .font(.Pretendard.Medium.size14)
                    .foregroundStyle(Color.my538F53)
                
                Spacer()
                Button(action: {
                    print("share")
                }){
                    Image(systemName: "square.and.arrow.up")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 25)
                        .foregroundStyle(Color.my566956)
                }
                .padding(.trailing, 6)
                
                Button(action: {
                    print("gear")
                }){
                    Image(systemName: "gear")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25)
                        .foregroundStyle(Color.my566956)
                }
            }
            .padding(.vertical)
            
            // 구분선
            Rectangle()
                .padding(.horizontal, -40) // 패딩 값 무시하기 위함
                .frame(maxWidth: .infinity, maxHeight: 1)
                .foregroundStyle(Color.myDBD1C5)
            
            Spacer()
            
            // 목표 & 마감일까지 남은 시간
            HStack {
                // 목표 시트 버튼
                Button(action: {
                    mainIsPresented = true
                }){
                    VStack(alignment: .leading, spacing: 4) {
                        Text("나의 목표")
                            .foregroundStyle(Color.myD5F3D1)
                            .font(.Pretendard.Medium.size14)
                        
                        Text(mainGoal?.title ?? "목표없음")
                            .foregroundStyle(.white)
                            .font(.Pretendard.Bold.size16)
                            .kerning(-0.32) // 자간
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // 전체 너비에서 왼쪽 정렬
                    .padding(.horizontal,10)
                    .padding(.vertical)
                    .background(Color.my538F53)
                    .cornerRadius(12)
                }
                .sheet(isPresented: $mainIsPresented) {
                    MainGoalsheetView(mainGoal: $mainGoal, isPresented: $mainIsPresented)
                        .presentationDragIndicator(.visible)
                        .presentationDetents([.height(244/852 * UIScreen.main.bounds.height)])
                }
                
                // 마감일 표시
                VStack(alignment: .leading, spacing: 4) {
                    Text("이번주 마감까지")
                        .font(.Pretendard.Medium.size12)
                    Text(dateManager.getTodayDText())
                        .font(.Pretendard.Bold.size20)
                }
                .padding(.horizontal,10)
                .padding(.vertical)
                .frame(width: 97/393 * UIScreen.main.bounds.width, alignment: .leading) // 전체 너비에서 왼쪽 정렬
                .background(Color.myEAEDE1)
                .cornerRadius(12)
            }
            .frame(height: 76/852 * UIScreen.main.bounds.height)
            .padding(.bottom, 25/852 * UIScreen.main.bounds.height)
            
            ZStack {
                // 만다라트 그리드
                if let selectedMainGoal = mainGoal {
                    let sortedSubGoals = selectedMainGoal.subGoals.sorted(by: { $0.id < $1.id }) // 정렬된 SubGoals 배열
                    
                    LazyVGrid(columns: outerColumns, spacing: 32) {
                        ForEach(0..<4, id: \.self) { index in
                            SubGoalCell(isPresented: $isPresented, selectedSubGoal: Binding(
                                get: { sortedSubGoals[index] },
                                set: { _ in }
                            ))
                        }
                    }
                } else {
                    Text("찾을 수 없습니다.")
                }
                
                // 메인골 자리
                RoundedRectangle(cornerSize: CGSize(width: 30, height: 30))
                    .fill(Color.my538F53)
                    .frame(width: 69, height: 69)
            }
            
            Spacer()
            
            // 다라 & comment
            HStack() {
                Image("Turtle_5")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 73/393 * UIScreen.main.bounds.width)
                
                ZStack{
                    Image("comment")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 55)
                    Text("한 걸음씩 가다 보면\n어느새 큰 변화를 느낄 거예요!")
                        .font(.Pretendard.Medium.size14)
                }
            }
            .padding(.bottom, 47/852 * UIScreen.main.bounds.height)
        }
        .padding(.horizontal, 20/393 * UIScreen.main.bounds.width)
    }
}

// MainGoalCell(subGoal: $subGoal, mainGoal: $mainGoal, isPresented: $isPresented)
