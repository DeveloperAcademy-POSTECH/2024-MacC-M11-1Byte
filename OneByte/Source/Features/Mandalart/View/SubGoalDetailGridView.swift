//
//  SubGoalDetailGridView.swift
//  OneByte
//
//  Created by 트루디 on 11/11/24.
//

import SwiftUI
import SwiftData

// MARK: 두번째 화면 - 클릭된 셀의 SubGoal 및 관련된 DetailGoals만 3x3 그리드로 표시하는 뷰
struct SubGoalDetailGridView: View {
    @State var detailNavigation: Bool = false
    @State var subNavigation: Bool = false
    @State private var selectedDetailGoal: DetailGoal?
    @State var subSheetIsPresented: Bool = false
    @State private var isModified: Bool = false
    @State private var showAlertDetail: Bool = false
    @State private var showAlertSub: Bool = false
    @Binding var subGoal: SubGoal?
    @Binding var tabBarVisible: Bool
    @Binding var isTabBarMainVisible: Bool
    @Binding var isSubNavigation: Bool
    
    private let viewModel = MandalartViewModel(
        createService: CreateService(),
        updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []),
        deleteService: DeleteService(mainGoals: [], subGoals: [], detailGoals: [])
    )
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if let selectedSubGoal = subGoal {
                let sortedDetailGoals = selectedSubGoal.detailGoals.sorted(by: { $0.id < $1.id })
                Spacer()
                LazyVGrid(columns: Array(repeating: GridItem(.fixed(123/852 * UIScreen.main.bounds.height)), count: 2), spacing: 5) {
                    ForEach(0..<4, id: \.self) { index in
                        let cornerRadius: CGFloat = 48
                        let cornerStyle = cornerStyle(for: index) // cornerStyle 함수 사용
                        
                        if index == (4 - selectedSubGoal.id) {
                            subGoalContent()
                        } else {
                            // 나머지 셀에 디테일골 제목 표시
                            let detailGoalIndex = index < (4 - selectedSubGoal.id) ? index : index - 1
                            if detailGoalIndex < sortedDetailGoals.count {
                                let detailGoal = sortedDetailGoals[detailGoalIndex]
                                
                                if selectedSubGoal.title == "" {
                                    // 회색 네모
                                    Text("")
                                        .frame(width: 123/393 * UIScreen.main.bounds.width, height: 123/852 * UIScreen.main.bounds.height)
                                        .foregroundStyle(.black)
                                        .cornerRadius(8)
                                        .background(.myE4E4E4)
                                        .cornerRadius(18)
                                        .cornerRadius(cornerRadius, corners: cornerStyle, defaultRadius: 18)
                                } else {
                                    ZStack(alignment: .topLeading) {
                                        Button(action: {
                                            let detailGoal = sortedDetailGoals[detailGoalIndex]
                                            selectedDetailGoal = detailGoal
                                            detailNavigation = true
                                        }) {
                                            Text(detailGoal.title == "" ?  "눌러서 루틴 추가하기" : detailGoal.title)
                                                .font(detailGoal.title == "" ? .Pretendard.Medium.size14 : .Pretendard.Medium.size16)
                                                .padding(14)
                                                .padding(.top, detailGoalIndex == 0 || detailGoalIndex == 1 ? 4 : 0)
                                                .padding(.leading, detailGoalIndex == 0 || detailGoalIndex == 3 ? 4 : 0)
                                                .padding(.trailing, detailGoalIndex == 1 || detailGoalIndex == 3 ? 4 : 0)
                                                .padding(.bottom, detailGoalIndex == 2 || detailGoalIndex == 3 ? 4 : 0)
                                                .frame(width: 123/393 * UIScreen.main.bounds.width, height: 123/852 * UIScreen.main.bounds.height)
                                                .foregroundStyle(detailGoal.title == "" ? Color.black.opacity(0.3) : .black)
                                                .cornerRadius(8)
                                                .background(Color.myBFEBBB)
                                        }
                                        .disabled(isModified)
                                        .cornerRadius(18)
                                        .cornerRadius(cornerRadius, corners: cornerStyle, defaultRadius: 18)
                                        .contextMenu {
                                            Button(role: .destructive) {
                                                viewModel.deleteDetailGoal(detailGoal: detailGoal)
                                            } label: {
                                                Label("삭제하기", systemImage: "trash")
                                            }
                                            
                                        }
                                        // 편집 버튼
                                        if isModified && detailGoal.title != ""{
                                            Button(action: {
                                                showAlertDetail = true
                                            }, label: {
                                                Image(systemName: "minus.circle.fill")
                                                    .frame(width: 24, height: 22, alignment: .topLeading)
                                            })
                                            .padding(5)
                                            .foregroundStyle(.red)
                                            .alert("루틴을 삭제하시겠습니까?", isPresented: $showAlertDetail) {
                                                Button("삭제하기", role: .destructive) {
                                                    viewModel.deleteDetailGoal(detailGoal: detailGoal)
                                                }
                                                Button("취소", role: .cancel) {}
                                            } message: {
                                                Text("삭제한 루틴은 다시 되돌릴 수 없어요.")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationDestination(isPresented: $detailNavigation) {
                    let detailGoal = selectedDetailGoal
                    DetailGoalView(detailGoal: .constant(detailGoal), tabBarVisible: $tabBarVisible)
                }
                .navigationDestination(isPresented: $subNavigation) {
                    let subGoal = selectedSubGoal
                    SubGoalView(subGoal: .constant(subGoal), tabBarVisible: $tabBarVisible, subNavigation: $subNavigation)
                }
                .padding(.top, 55)
                // 메모 모아보기
                memoes()
                
            } else {
                ProgressView("loading..")
            }
        } // VStack 끝
        .toolbar {
            ToolbarItem(placement: .topBarTrailing, content: {
                Button(action: {
                    isModified.toggle()
                }, label: {
                    Text(isModified ? "완료": "편집")
                        .foregroundStyle(.my538F53)
                        .font(.Pretendard.SemiBold.size17)
                })
            })
        }
        .padding(.horizontal)
        .navigationBarBackButtonHidden()
        .backButtonToolbar {
            isSubNavigation = false
        }
        .background(Color.myFFFAF4)
        .navigationTitle(subGoal?.title ?? "")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(tabBarVisible ? .visible : .hidden, for: .tabBar)
        .onAppear{
            tabBarVisible = false
            isTabBarMainVisible = false
        }
    }
}

extension SubGoalDetailGridView {
    // MARK: 섭골 부분
    @ViewBuilder
    func subGoalContent() -> some View {
        if let selectedSubGoal = subGoal {
            ZStack(alignment: .topLeading) {
                // 네 번째 셀에 서브골 제목 표시
                Button(action: {
                    subNavigation = true
                }, label: {
                    Text(selectedSubGoal.title == "" ? "눌러서 목표 추가하기" : selectedSubGoal.title)
                        .padding()
                        .font(selectedSubGoal.title == "" ? .Pretendard.Medium.size17: .Pretendard.Bold.size17)
                        .frame(width: 123/393 * UIScreen.main.bounds.width, height: 123/852 * UIScreen.main.bounds.height)
                        .foregroundStyle(selectedSubGoal.title == "" ? .white.opacity(0.7) : .white)
                        .cornerRadius(8)
                        .background(Color.my95D895)
                })
                .disabled(isModified)
                .cornerRadius(18)
                .contextMenu {
                    Button(role: .destructive){
                        viewModel.deleteSubDetailGoals(subGoal: selectedSubGoal)
                    } label: {
                        Label("삭제하기", systemImage: "trash")
                    }
                }
                // 편집 버튼
                if isModified && selectedSubGoal.title != ""{
                    Button(action: {
                        showAlertSub = true
                    }, label: {
                        Image(systemName: "minus.circle.fill")
                            .frame(width: 24, height: 22, alignment: .topLeading)
                    })
                    .padding(5)
                    .foregroundStyle(.red)
                    .alert("목표를 삭제하시겠습니까?", isPresented: $showAlertSub) {
                        Button("삭제하기", role: .destructive) {
                            viewModel.deleteSubDetailGoals(subGoal: selectedSubGoal)
                        }
                        Button("취소", role: .cancel) {}
                    } message: {
                        Text("목표를 삭제하면 목표에 해당하는 루틴들도 일괄 삭제돼요.")
                    }
                }
            }
        }
    }
    // MARK: 메모 리스트
    @ViewBuilder
    func memoes() -> some View {
        // 메모 모아보기 리스트
        if let selectedSubGoal = subGoal {
            let sortedDetailGoals = selectedSubGoal.detailGoals.sorted(by: { $0.id < $1.id })
            let filteredMemos = sortedDetailGoals.filter { !$0.memo.isEmpty }
            
            if !filteredMemos.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    Text("메모 모아보기")
                        .font(.Pretendard.SemiBold.size18)
                        .padding(.top, 47)
                    
                    ScrollView {
                        VStack(spacing: 8) {
                            ForEach(filteredMemos, id: \.id) { detailGoal in
                                HStack(spacing: 14) {
                                    let randomFace = ["Face1", "Face2", "Face3"].randomElement() ?? "Face1"
                                    Image(randomFace) // 랜덤 아이콘
                                        .scaledToFit()
                                        .frame(width: 33/393 * UIScreen.main.bounds.width)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(detailGoal.title) // 디테일골 제목
                                            .font(.Pretendard.Bold.size16)
                                            .foregroundStyle(Color.my2D5C2D)
                                        
                                        Text(detailGoal.memo) // 디테일골 메모
                                            .font(.Pretendard.Medium.size14)
                                            .foregroundStyle(Color.my657665)
                                    }
                                    Spacer()
                                }
                                .padding(20)
                                .background(.white)
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.myF0E8DF, lineWidth: 1)
                                )
                            }
                        }
                    }
                }
            } else {
                HStack(){
                    Text("메모 모아보기")
                        .font(.Pretendard.SemiBold.size18)
                        .padding(.top, 47)
                    Spacer()
                }
                Image("Turtle_Empty")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 149/852 * UIScreen.main.bounds.height)
                    .padding(.top, 53)
                Text("아직 메모가 없어요!")
                    .font(.Pretendard.SemiBold.size16)
                    .padding(.vertical, 10)
                Text("루틴에 대한 메모를 작성하고 확인해 보세요.")
                    .font(.Pretendard.Medium.size14)
                    .foregroundStyle(Color.my878787)
                    .padding(.bottom, 79)
                Spacer()
            }
        }
    }
}
