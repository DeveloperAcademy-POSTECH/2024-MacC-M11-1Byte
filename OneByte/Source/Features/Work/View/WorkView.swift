//
//  WorkView.swift
//  OneByte
//
//  Created by 트루디 on 10/17/24.
//

import SwiftUI
import SwiftData

enum routineTapInfo : String, CaseIterable {
    case today = "오늘의 루틴"
    case all = "전체 루틴"
}

// MARK: 루틴 메인 뷰
struct WorkView: View {
    
    @State private var selectedPicker: routineTapInfo = .today
    @Namespace private var animation
    var routineType : routineTapInfo
    
    var body: some View {
        ZStack {
            Color.my6FB56F
                .ignoresSafeArea(edges: .top)
            
            VStack(spacing: 0) {
                HStack {
                    Text("할 일")
                        .font(.Pretendard.Bold.size22)
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    NavigationLink {
                        SettingView()
                    } label: {
                        Image(systemName: "gear")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.myCEEDCE)
                    }
                }
                .padding()
                
                HStack{
                    Text("완벽하지 않아도 괜찮아요.\n중요한 것은 꾸준히 다시 시작하는 거예요!")
                        .font(.Pretendard.Medium.size14)
                        .foregroundStyle(Color.my3C3C3C)
                    Image("Turtle_Main")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 105, height: 85)
                }
                .padding()
                .background(Color.my6FB56F)
                
                VStack(spacing: 0) {
                    animate() // Tabbar Picker
                    Divider()
                        .foregroundStyle(Color.myF0E8DF)
                    
                    ScrollView(.vertical, showsIndicators: false) { // Picker에 따른 뷰
                        switch selectedPicker {
                        case .today:
                            TodayRoutineView()
                        case .all:
                            AllRoutineView()
                        }
                    }
                }
                .background(Color.myFFFAF4)
                .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
            }
        }
    }
    
    @ViewBuilder
    private func animate() -> some View {
        HStack {
            ForEach(routineTapInfo.allCases, id: \.self) { item in
                VStack {
                    Text(item.rawValue)
                        .font(.Pretendard.Bold.size17)
                        .frame(maxWidth: .infinity/4, minHeight: 50)
                        .foregroundStyle(selectedPicker == item ? Color.my1D1D1D : .gray)
                    
                    if selectedPicker == item {
                        Capsule()
                            .foregroundStyle(Color.my95D895)
                            .frame(height: 2)
                            .padding(.horizontal, 40)
                            .matchedGeometryEffect(id: "info", in: animation)
                    }
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

#Preview {
    WorkView(routineType: .today)
}
