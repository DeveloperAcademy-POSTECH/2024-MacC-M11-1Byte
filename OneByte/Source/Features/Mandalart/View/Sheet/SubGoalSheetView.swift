import SwiftUI

struct SubGoalsheetView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.managedObjectContext) private var context
    @Binding var subGoal: SubGoal?
    @Binding var isPresented: Bool
    
    @State private var selectedCategory: String = "" // 기본값
    @State private var isCustomCategoryActive: Bool = false // "기타" 상태 관리
    
    let categories = ["건강", "학업", "여행", "저축", "자기계발", "취미 생활", "가족", "새로운 도전"]
    
    private let titleLimit = 20 // 제목 글자수 제한
    
    @State private var newTitle: String = ""
    @State private var leafState: Int = 0
    private let viewModel = MandalartViewModel(
        createService: CreateService(),
        updateService: UpdateService(mainGoals: [], subGoals: [], detailGoals: []),
        deleteService: DeleteService(mainGoals: [], subGoals: [], detailGoals: [])
    )
    
    var body: some View {
        VStack {
            // 카테고리 선택 버튼 (FlowLayout 대신)
            categorySelectionGrid(
                categories: categories,
                selectedCategory: $selectedCategory,
                isCustomCategoryActive: $isCustomCategoryActive
            )
            
            // "기타" 선택 시 텍스트 필드 표시
            if isCustomCategoryActive {
                TextField("카테고리를 입력하세요", text: $selectedCategory)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.vertical, 10)
            }
            
            Text("하위 목표")
                .font(.Pretendard.SemiBold.size17)
                .padding(.top, 22/852 * UIScreen.main.bounds.height)
            
            // 하위 목표 제목 입력란
            ZStack {
                TextField("하위 목표를 입력해주세요", text: $newTitle)
                    .padding()
                    .background(.white)
                    .font(.Pretendard.Medium.size16)
                    .cornerRadius(12)
                    .onChange(of: newTitle) { oldValue, newValue in
                        if newValue.count > titleLimit {
                            newTitle = String(newValue.prefix(titleLimit))
                        }
                    }
                HStack {
                    Spacer()
                    if newTitle != "" {
                        Button(action: {
                            newTitle = ""
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 23, height: 23)
                                .foregroundStyle(Color.myB9B9B9)
                        })
                        .padding(.trailing)
                    }
                }
            }
            .padding(.top, 20/852 * UIScreen.main.bounds.height)
            
            // 글자수 부분
            HStack(spacing: 0) {
                Spacer()
                Text("\(newTitle.count)")
                    .font(.Pretendard.Medium.size12)
                    .foregroundStyle(Color.my6C6C6C)
                Text("/\(titleLimit)")
                    .font(.Pretendard.Medium.size12)
                    .foregroundStyle(Color.my6C6C6C.opacity(0.5))
            }
            .padding(.trailing, 10)
            
            Spacer()
            
            // 버튼 영역
            HStack {
                Button(action: {
                    isPresented = false
                }) {
                    Text("취소")
                        .frame(maxWidth: .infinity)
                        .font(.Pretendard.Medium.size16)
                        .padding()
                        .background(Color.my787880.opacity(0.2))
                        .foregroundStyle(Color.my3C3C43.opacity(0.6))
                        .cornerRadius(12)
                }
                
                Button(action: {
                    if let subGoal = subGoal {
                        viewModel.updateSubGoal(
                            subGoal: subGoal,
                            newTitle: newTitle,
                            leafState: leafState,
                            category: selectedCategory)
                    }
                    isPresented = false
                }) {
                    Text("저장")
                        .frame(maxWidth: .infinity)
                        .font(.Pretendard.Medium.size16)
                        .padding()
                        .background(newTitle == "" ? Color.my538F53.opacity(0.7) : Color.my538F53)
                        .foregroundStyle(newTitle == "" ? .white.opacity(0.7) : .white)
                        .cornerRadius(12)
                }
                .disabled(newTitle == "")
            }
        }
        .padding(.horizontal)
        .background(Color.myF1F1F1)
        .onAppear {
            if let subGoal = subGoal{
                let result = viewModel.initializeSubGoal(
                    subGoal: subGoal,
                    categories: categories
                )
                selectedCategory = result.0
                isCustomCategoryActive = result.1
                newTitle = subGoal.title
            }
        }
    }
}

extension SubGoalsheetView {
    @ViewBuilder
    func categorySelectionGrid(
        categories: [String],
        selectedCategory: Binding<String>,
        isCustomCategoryActive: Binding<Bool>
    ) -> some View {
        LazyVGrid(
            columns: [GridItem(.adaptive(minimum: 80), spacing: 10)],
            spacing: 10
        ) {
            ForEach(categories, id: \.self) { category in
                Button(action: {
                    isCustomCategoryActive.wrappedValue = false
                    selectedCategory.wrappedValue = category
                }) {
                    Text(category)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(
                            selectedCategory.wrappedValue == category
                            ? Color.green
                            : Color.gray.opacity(0.2)
                        )
                        .foregroundColor(
                            selectedCategory.wrappedValue == category
                            ? .white
                            : .black
                        )
                        .cornerRadius(16)
                }
            }
            
            // "기타" 버튼
            Button(action: {
                isCustomCategoryActive.wrappedValue = true
                selectedCategory.wrappedValue = "" // 선택된 카테고리를 초기화
            }) {
                Text("기타")
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(isCustomCategoryActive.wrappedValue ? Color.green : Color.gray.opacity(0.2))
                    .foregroundColor(isCustomCategoryActive.wrappedValue ? .white : .black)
                    .cornerRadius(16)
            }
        }
    }
}
