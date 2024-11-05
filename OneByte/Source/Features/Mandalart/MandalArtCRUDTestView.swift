////
////  ObjectiveView.swift
////  OneByte
////
////  Created by 트루디 on 10/29/24.
////
//
//import SwiftUI
//import SwiftData
//
//struct CUTestView: View {
//    
//    @Environment(\.modelContext) var modelContext
//    @Query private var mainGoals: [MainGoal]
//    
//    @State var goalTitle: String = ""
//    @State private var selectedGoal: MainGoal? // 수정할 메인골
//    @State private var isEditing = false
//    
//    @StateObject private var viewModel: CUTestViewModel
//    init(viewModel: CUTestViewModel) {
//        _viewModel = StateObject(wrappedValue: viewModel)
//    }
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                if isEditing, let selectedGoal = selectedGoal {
//                    // 수정 모드 UI
//                    TextField("수정할 메인 골을 입력해주세요", text: $goalTitle)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding()
//                    
//                    Button(action: {
//                        selectedGoal.title = goalTitle
//                        isEditing = false
//                        goalTitle = ""
//                    }, label: {
//                        Text("수정 완료")
//                    })
//                } else {
//                    // 메인골 생성 UI
//                    TextField("메인 골을 입력해주세요", text: $goalTitle)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding()
//                    
//                    Button(action: {
//                        viewModel.createMainGoal(modelContext: modelContext, id: , title: <#T##String#>, goalYear: <#T##Int#>, createdTime: <#T##Date#>, modifiedTime: <#T##Date#>, subGoals: <#T##[SubGoal]#>)
//                        goalTitle = ""
//                    }, label: {
//                        Text("메인Goal 생성")
//                    })
//                }
//                
//                // 메인골 리스트: 완료 여부, 섭골 이동 버튼, 제목 수정 버튼, 제목 삭제 버튼
//                List {
//                    ForEach(mainGoals, id: \.id) { goal in
//                        Section(header: Text(goal.title).font(.headline)) {
//                            // 완료 여부 토글
//                            Toggle(isOn: Binding(
//                                get: { goal.isAchieved },
//                                set: { newValue in
//                                    goal.isAchieved = newValue
//                                }
//                            )) {
//                                Text(goal.isAchieved ? "완료" : "미완료")
//                            }
//                            .toggleStyle(SwitchToggleStyle())
//                            
//                            // 서브골로 넘어가는 네비게이션 링크
//                            NavigationLink(destination: SubGoalView(mainGoalId: goal.id, viewModel: viewModel, mainGoal: goal)) {
//                                Text("서브Goal로 이동")
//                                    .font(.subheadline)
//                                    .foregroundColor(.blue)
//                            }
//                            
//                            // 목표 제목 수정 버튼
//                            Button(action: {
//                                selectedGoal = goal
//                                goalTitle = goal.title
//                                isEditing = true
//                            }) {
//                                Text("제목 수정")
//                                    .font(.subheadline)
//                                    .foregroundColor(.blue)
//                            }
//                            
//                            // 삭제
//                            Button(action: {
//                                selectedGoal = goal
//                                goal.title = ""
//                            }, label: {
//                                Text("제목 삭제")
//                                    .font(.subheadline)
//                                    .foregroundColor(.blue)
//                            })
//                        }
//                    }
//                }
//            }
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//    }
//}
//
//struct SubGoalView: View {
//    
//    @Environment(\.modelContext) var modelContext
//    @State private var subGoalTitle: String = ""
//    let mainGoalId: UUID
//    @ObservedObject var viewModel: CUTestViewModel
//    let mainGoal: MainGoal
//    
//    @State private var selectedSubGoal: SubGoal? // 수정할 서브 골
//    @State private var isEditing = false // 수정 모드 여부
//    
//    @Query private var subGoals: [SubGoal]
//    
//    init(mainGoalId: UUID, viewModel: CUTestViewModel, mainGoal: MainGoal) {
//        self.mainGoalId = mainGoalId
//        self.viewModel = viewModel
//        self.mainGoal = mainGoal
//        
//        _subGoals = Query(filter: #Predicate<SubGoal> { subGoal in
//            subGoal.mainGoal?.id == mainGoalId
//        })
//    }
//    
//    var body: some View {
//        VStack {
//            if isEditing, let selectedSubGoal = selectedSubGoal {
//                // 수정 모드 UI
//                TextField("서브 골을 수정해주세요", text: $subGoalTitle)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                
//                Button(action: {
//                    selectedSubGoal.title = subGoalTitle
//                    isEditing = false
//                    subGoalTitle = ""
//                }, label: {
//                    Text("수정 완료")
//                })
//            } else {
//                // 섭골 생성 UI
//                TextField("서브 골을 입력해주세요", text: $subGoalTitle)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                
//                Button(action: {
//                    viewModel.createSubGoal(modelContext: modelContext, mainGoal: mainGoal, title: subGoalTitle, isAchieved: false)
//                    subGoalTitle = ""
//                }, label: {
//                    Text("서브Goal 생성")
//                })
//            }
//            
//            // SubGoal 리스트: 완료 여부, 디태일골 이동 버튼, 제목 수정 버튼, 제목 삭제 버튼
//            List {
//                ForEach(subGoals, id: \.id) { subGoal in
//                    Section(header: Text(subGoal.title).font(.headline)) {
//                        // SubGoal 완료 여부 토글
//                        Toggle(isOn: Binding(
//                            get: { subGoal.isAchieved },
//                            set: { newValue in
//                                subGoal.isAchieved = newValue
//                            }
//                        )) {
//                            Text(subGoal.isAchieved ? "완료" : "미완료")
//                        }
//                        .toggleStyle(SwitchToggleStyle())
//                        
//                        // 디테일Goal 화면으로 이동하는 NavigationLink
//                        NavigationLink(destination: detailGoalView(subGoalId: subGoal.id, viewModel: viewModel, subGoal: subGoal)) {
//                            Text("디테일Goal로 이동")
//                                .font(.subheadline)
//                                .foregroundColor(.blue)
//                        }
//                        
//                        // SubGoal 수정 버튼
//                        Button(action: {
//                            selectedSubGoal = subGoal
//                            subGoalTitle = subGoal.title
//                            isEditing = true
//                        }) {
//                            Text("제목 수정")
//                                .font(.subheadline)
//                                .foregroundColor(.blue)
//                        }
//                        
//                        // 삭제
//                        Button(action: {
//                            selectedSubGoal = subGoal
//                            subGoal.title = ""
//                        }, label: {
//                            Text("제목 삭제")
//                                .font(.subheadline)
//                                .foregroundColor(.blue)
//                        })
//                    }
//                }
//            }
//        }
//        .navigationTitle(mainGoal.title)
//    }
//}
//
//struct detailGoalView: View {
//    @Environment(\.modelContext) var modelContext
//    @State private var detailGoalTitle: String = ""
//    @State private var isEditing = false
//    @State private var selectedDetailGoal: DetailGoal?
//    
//    let subGoalId: UUID
//    @ObservedObject var viewModel: CUTestViewModel
//    let subGoal: SubGoal
//    
//    @Query private var detailGoals: [DetailGoal]
//    
//    init(subGoalId: UUID, viewModel: CUTestViewModel, subGoal: SubGoal) {
//        self.subGoalId = subGoalId
//        self.viewModel = viewModel
//        self.subGoal = subGoal
//        
//        // subGoal에 속한 detailGoals만 필터링
//        _detailGoals = Query(filter: #Predicate<DetailGoal> { detailGoal in
//            detailGoal.subGoal?.id == subGoalId
//        })
//    }
//    
//    var body: some View {
//        VStack {
//            if isEditing, let selectedDetailGoal = selectedDetailGoal {
//                // 수정 모드 UI
//                TextField("detail 골을 수정해주세요", text: $detailGoalTitle)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                
//                Button(action: {
//                    selectedDetailGoal.title = detailGoalTitle
//                    isEditing = false
//                    detailGoalTitle = ""
//                }, label: {
//                    Text("수정 완료")
//                })
//            } else {
//                // 섭골 셍성 UI
//                TextField("detail 골을 입력해주세요", text: $detailGoalTitle)
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .padding()
//                
//                Button(action: {
//                    viewModel.createDetailGoal(modelContext: modelContext, subGoal: subGoal, title: detailGoalTitle, isAchieved: false)
//                    detailGoalTitle = ""
//                }, label: {
//                    Text("detail Goal 생성")
//                })
//                
//            }
//            // detailGoal 리스트: 완료 여부, 제목 수정 버튼, 제목 삭제 버튼
//            List {
//                ForEach(detailGoals, id: \.id) { detailGoal in
//                    Section(header: Text(detailGoal.title).font(.headline)) {
//                        // SubGoal 완료 여부 토글
//                        Toggle(isOn: Binding(
//                            get: { detailGoal.isAchieved },
//                            set: { newValue in
//                                detailGoal.isAchieved = newValue
//                            }
//                        )) {
//                            Text(detailGoal.isAchieved ? "완료" : "미완료")
//                        }
//                        .toggleStyle(SwitchToggleStyle())
//                        
//                        // detailGoal 수정 버튼
//                        Button(action: {
//                            selectedDetailGoal = detailGoal
//                            detailGoalTitle = detailGoal.title
//                            isEditing = true
//                        }) {
//                            Text("제목 수정")
//                                .font(.subheadline)
//                                .foregroundColor(.blue)
//                        }
//                        
//                        // 삭제
//                        Button(action: {
//                            selectedDetailGoal = detailGoal
//                            detailGoal.title = ""
//                        }, label: {
//                            Text("제목 삭제")
//                                .font(.subheadline)
//                                .foregroundColor(.blue)
//                        })
//                    }
//                }
//            }
//        }
//        .navigationTitle(subGoal.title)
//    }
//}
