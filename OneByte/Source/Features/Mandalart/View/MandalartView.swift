//
//  ObjectiveView.swift
//  OneByte
//
//  Created by 트루디 on 11/03/24.
//
import SwiftUI
import SwiftData

struct MandalartView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var requestNotification: Bool = true
    @State var isPresented = false
    @State private var mainGoal: MainGoal?
   
    @Binding var isTabBarMainVisible: Bool
    
    @Query private var mainGoals: [MainGoal]
    
    var body: some View {
        NavigationStack() {
            ZStack {
                Color.myFFFAF4
                    .ignoresSafeArea(edges: .top)
                if let firstMainGoal = mainGoals.first {
                    OuterGridView(mainGoal: $mainGoal, isTabBarMainVisible: $isTabBarMainVisible)
                        .environment(\.modelContext, modelContext)
                        .onAppear {
                            mainGoal = firstMainGoal
                        }
                }
            }
        }
        .onAppear {
            isTabBarMainVisible = true
            if requestNotification {
                requestNotificationPermission()
            }
        }
    }
}

// MARK: 첫화면 -  전체 81개짜리
struct OuterGridView: View {
    @Binding var mainGoal: MainGoal?
    @Binding var isTabBarMainVisible: Bool

    @State private var capturedImage: UIImage? = nil
    @State var mainIsPresented: Bool = false
    @State private var selectedSubGoal: SubGoal? // 선택된 SubGoal을 관리
    @State private var isSubNavigationActive: Bool = false // 네비게이션 활성화 상태
    @State var tabBarVisible: Bool = true
    @State private var showAlert = false 
    @State private var isEdited = false
    
    private let dateManager = DateManager()
    private let currentDate = Date()
    private let outerColumns = [GridItem(.adaptive(minimum: 160/393 * UIScreen.main.bounds.width), spacing: 32/393 * UIScreen.main.bounds.width)]
    private let viewModel = MandalartViewModel(
        createService: CreateService(),
        updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []),
        deleteService: DeleteService(mainGoals: [], subGoals: [], detailGoals: [])
    )
    
    @State private var currentMessage: String = ""
       private let messages: [String] = [
           "완벽하지 않아도 괜찮아요.\n중요한 것은 꾸준히 다시 시작하는 거예요!",
           "한 걸음씩 가다 보면 \n어느새 큰 변화를 느낄 거예요!",
           "같이 좀만 더 힘내봐요! \n조금만 힘내면 금새 습관이 될거예요.",
           "누가 그랬는데 \n탁월함은 행동이 아니라 습관에서 온대요.",
           "오늘 조금 못해도 괜찮아요, \n내일은 더 잘할 수 있을거예요.",
           "느려도 괜찮아요.\n꾸준함이 우리를 목표로 데려다줄 거예요.",
           "중단했더라도 괜찮아요.\n중요한 건 포기하지 않는 마음이에요."
       ]
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 날짜 및 공유, 설정 버튼
            HStack(alignment: .center ,spacing: 0) {
                // 한국 날짜 형식으로 오늘 날짜 표시
                Text("클로버 심기")
                    .font(.Pretendard.Bold.size22)
                    .foregroundStyle(Color.myB4A99D)
                    .padding(.leading, -6)
                
                Spacer()
                
                Button(action: {
                    print("share")
                    
                }){
                    if let image = capturedImage {
                        let newImage = Image(uiImage: image)
                        ShareLink(
                            item: newImage,
                            preview: SharePreview("공유할 이미지", image: newImage)
                        ) {
                            Label("", systemImage: "square.and.arrow.up")
                                .aspectRatio(contentMode: .fit)
                                .foregroundStyle(Color.my566956)
                                .font(.system(size: 20, weight: .medium))
                            // 이부분은 프리텐다드로 하면 적용이 안됨!
                        }
                    }
                }
                .padding(.trailing, 14)
                
                NavigationLink {
                    SettingView(isTabBarMainVisible: $isTabBarMainVisible)
                } label: {
                    Image("SettingDark")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.horizontal, 10)
            .padding(.top, 8)
            
            // 목표 & 만다라트 그리드
            captureView()
            Spacer()
            
            // 다라 & comment
            HStack() {
                Button(action: {
                    viewModel.triggerHapticOn()
                    currentMessage = messages.randomElement() ?? currentMessage
                }, label: {
                    Image("Turtle_5")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 73/393 * UIScreen.main.bounds.width)
                })
                Text(currentMessage)
                    .font(.Pretendard.Medium.size14)
                    .multilineTextAlignment(.leading)
                    .padding(EdgeInsets(top: 10, leading: 15, bottom: 10, trailing: 15))
                    .background(
                        Image("comment")
                            .resizable()
                            .scaledToFill()
                    )
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.bottom, 47/852 * UIScreen.main.bounds.height)
            Spacer()
        }
        .onAppear {
            currentMessage = messages.randomElement() ?? ""
            isTabBarMainVisible = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                capturedImage = captureView()
                    .padding()
                    .padding(.top, -30)
                    .snapshot()
            }
        }
        .padding(.horizontal)
        .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
        .alert("작업을 중단하시겠습니까?", isPresented: $showAlert) {
            Button("나가기", role: .destructive) {
                mainIsPresented = false  // 시트 닫기
            }
            Button("계속하기", role: .cancel) {}
        } message: {
            Text("작성한 내용이 저장되지 않아요.")
        }
    }
}

extension OuterGridView {
    @ViewBuilder
    func captureView() -> some View {
        VStack {
            // 목표
            HStack(spacing: 0) {
                // 목표 시트 버튼
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 0) {
                        Text("나의 다짐")
                            .foregroundStyle(Color.myD5F3D1)
                            .font(.Pretendard.Medium.size14)
                        Spacer()
                        Button(action: {
                            mainIsPresented = true
                        }, label: {
                            Image(systemName: "pencil.line")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 28)
                                .foregroundStyle(mainGoal?.title == "" ? .myCEEDCE : .white)
                        })
                        .sheet(isPresented: $mainIsPresented) {
                            MainGoalsheetView(mainGoal: $mainGoal, isPresented: $mainIsPresented, isEdited: $isEdited)
                                .presentationDragIndicator(.visible)
                                .presentationDetents([.height(244/852 * UIScreen.main.bounds.height)])
                        }
                    }
                    if mainGoal?.title == "" {
                        Text("아직 나의 다짐을 작성하지 않았어요.")
                            .foregroundStyle(.white.opacity(0.5))
                            .font(.Pretendard.SemiBold.size16)
                    } else {
                        Text(mainGoal?.title ?? "")
                            .foregroundStyle(.white)
                            .font(.Pretendard.Bold.size16)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading) // 전체 너비에서 왼쪽 정렬
                .padding()
                .background(Color.my538F53)
                .cornerRadius(12)
            }
            .frame(height: 76/852 * UIScreen.main.bounds.height)
            .padding(.bottom, 30/852 * UIScreen.main.bounds.height)
            .padding(.top, 39/852 * UIScreen.main.bounds.height)
            
            // 만다라트 그리드
            ZStack {
                if let selectedMainGoal = mainGoal {
                    LazyVGrid(columns: outerColumns, spacing: 32/393 * UIScreen.main.bounds.width) {
                        let sortedSubGoals = selectedMainGoal.subGoals.sorted(by: { $0.id < $1.id }) // 정렬된 SubGoals 배열
                        ForEach(sortedSubGoals, id: \.id) { subGoal in
                            Button(action: {
                                isSubNavigationActive = true
                                selectedSubGoal = subGoal // 할당이 안되면 SubGoalDetailGridView에 전달이 안됨!
                            }, label: {
                                SubGoalCell(selectedSubGoal: .constant(subGoal))
                            })
                            
                        }
                    }
                    .navigationDestination(isPresented: $isSubNavigationActive) {
                        SubGoalDetailGridView(
                            subGoal: $selectedSubGoal,
                            tabBarVisible: $tabBarVisible,
                            isTabBarMainVisible: $isTabBarMainVisible,
                            isSubNavigation: $isSubNavigationActive
                        )
                    }
                }
                // 메인골 자리
                RoundedRectangle(cornerSize: CGSize(width: 30, height: 30))
                    .fill(Color.my538F53)
                    .frame(width: 69, height: 69)
            }
            Spacer()
        }
    }
}
struct Photo: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.image)
    }
    
    public var image: Image
    public var caption: String
}
