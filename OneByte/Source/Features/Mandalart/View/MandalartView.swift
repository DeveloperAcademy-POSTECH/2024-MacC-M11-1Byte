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
    @AppStorage("FirstOnboarding") var FirstOnboarding: Bool = true
    @Query private var mainGoals: [MainGoal]
    @State var isPresented = false
    @State private var mainGoal: MainGoal?
    @Binding var isTabBarMainVisible: Bool
    
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
                } else {
                    Text("MainGoal 데이터를 찾을 수 없습니다.")
                        .foregroundStyle(.gray)
                        .padding()
                }
            }
            .onAppear {
                isTabBarMainVisible = true
            }
            .fullScreenCover(isPresented: $FirstOnboarding) {
                OnboardingStartView()
            }
            .onChange(of: FirstOnboarding) { old, newValue in
                if !newValue {
                    requestNotificationPermission()
                }
            }
        }
    }
}

// MARK: 첫화면 -  전체 81개짜리
struct OuterGridView: View {
    @Environment(\.modelContext) private var modelContext  // SwiftData 컨텍스트
    @Environment(\.managedObjectContext) private var context
    
    @Binding var mainGoal: MainGoal?
    @State var mainIsPresented: Bool = false
    @Binding var isTabBarMainVisible: Bool
    
    private let dateManager = DateManager()
    private let currentDate = Date()
    private let outerColumns = [GridItem(.adaptive(minimum: 160/393 * UIScreen.main.bounds.width), spacing: 32/393 * UIScreen.main.bounds.width)]
    private let viewModel = MandalartViewModel(
        createService: CreateService(),
        updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []),
        deleteService: DeleteService(mainGoals: [], subGoals: [], detailGoals: [])
    )
    @State private var capturedImage: UIImage? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // 날짜 및 공유, 설정 버튼
            HStack(alignment: .center ,spacing: 8) {
                // 한국 날짜 형식으로 오늘 날짜 표시
                Text("나의 계획")
                    .font(.Pretendard.Bold.size22)
                    .foregroundStyle(Color.myB4A99D)
                
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
                .padding(.trailing, 10)
                
                NavigationLink {
                    SettingView(isTabBarMainVisible: $isTabBarMainVisible)
                } label: {
                    Image(systemName: "gear")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(.my566956)
                }
            }
            .padding(.vertical)
            
            // 목표 & 만다라트 그리드
            captureView()
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
            Spacer()
        }
        .onAppear {
            isTabBarMainVisible = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                capturedImage = captureView().padding().padding(.top, -30).snapshot()
            }
        }
        .padding(.horizontal, 20/393 * UIScreen.main.bounds.width)
        .background(Color.myFFFAF4)
        .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
    }
}

extension OuterGridView {
    @ViewBuilder
    func captureView() -> some View {
        VStack {
            // 목표
            HStack(spacing: 0) {
                // 목표 시트 버튼
                Button(action: {
                    mainIsPresented = true
                }){
                    VStack(alignment: .leading, spacing: 4) {
                        HStack(spacing: 0) {
                            Text("나의 다짐")
                                .foregroundStyle(Color.myD5F3D1)
                                .font(.Pretendard.Medium.size14)
                            Spacer()
                            Image(systemName: "ellipsis")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22)
                                .foregroundStyle(Color.myD5F3D1)
                        }
                        
                        Text(mainGoal?.title ?? "")
                            .foregroundStyle(.white)
                            .font(.Pretendard.Bold.size16)
                            .kerning(-0.32) // 자간
                    }
                    .frame(maxWidth: .infinity, alignment: .leading) // 전체 너비에서 왼쪽 정렬
                    .padding(.horizontal)
                    .padding(.vertical)
                    .background(Color.my538F53)
                    .cornerRadius(12)
                }
                .sheet(isPresented: $mainIsPresented) {
                    MainGoalsheetView(mainGoal: $mainGoal, isPresented: $mainIsPresented)
                        .presentationDragIndicator(.visible)
                        .presentationDetents([.height(244/852 * UIScreen.main.bounds.height)])
                }
            }
            .frame(height: 76/852 * UIScreen.main.bounds.height)
            .padding(.bottom, 30/852 * UIScreen.main.bounds.height)
            .padding(.top, 10/852 * UIScreen.main.bounds.height)
            
            // 만다라트 그리드
            ZStack {
                if let selectedMainGoal = mainGoal {
                    LazyVGrid(columns: outerColumns, spacing: 32/393 * UIScreen.main.bounds.width) {
                        let sortedSubGoals = selectedMainGoal.subGoals.sorted(by: { $0.id < $1.id }) // 정렬된 SubGoals 배열
                        ForEach(sortedSubGoals, id: \.id) { subGoal in
                            SubGoalCell(selectedSubGoal: .constant(subGoal), isTabBarMainVisible: $isTabBarMainVisible)
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
