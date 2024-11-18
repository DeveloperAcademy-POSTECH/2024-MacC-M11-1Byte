//
//  MyPageView.swift
//  OneByte
//
//  Created by 트루디 on 10/17/24.
//

import SwiftUI
import SwiftData

struct StatisticView: View {
    
    @State var viewModel = StatisticViewModel()
    @Query(
        filter: #Predicate<Clover> { $0.cloverYear == Calendar.current.component(.year, from: Date()) }
    ) var clovers: [Clover]
    
    var body: some View {
        ScrollView {
            VStack{
                // 최상단 헤더
                HStack {
                    Text("통계")
                        .font(.Pretendard.Bold.size22)
                        .foregroundStyle(Color.myB4A99D)
                    
                    Spacer()
                }
                .padding()
                
                // 이번달 클로버 정보
                thisMonthCloverInfoView()
                
                // 올해의 클로버 정보
                thisYearCloverInfoView()
                
                Spacer()
            }
        }
        .background(Color.myFFFAF4)
    }
    
    @ViewBuilder
    private func thisMonthCloverInfoView() -> some View {
        RoundedRectangle(cornerRadius: 20)
            .fill(Color.my6FB56F) // 배경색 (녹색)
            .frame(maxWidth: .infinity)
            .frame(height: 146)
            .padding()
            // ⚠️⚠️ 추가 구현
    }
    
    @ViewBuilder
    private func thisYearCloverInfoView() -> some View {
        VStack(spacing: 5){
            HStack {
                Text("올해의 클로버")
                    .font(.Pretendard.Bold.size18)
                    .padding(.leading, 5)
                Spacer()
            }
            HStack {
                Text("올해의 내가 수집한 클로버를 모아볼 수 있어요.")
                    .font(.Pretendard.Medium.size14)
                    .foregroundStyle(Color.myA8A8A8)
                    .padding(.leading, 5)
                Spacer()
            }
            
            HStack(alignment: .center) {
                VStack(spacing: 10) {
                    HStack {
                        Text("내가 모은 황금 클로버")
                            .font(.Pretendard.Medium.size15)
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "star.fill")
                        
                        Text("5")
                            .font(.Pretendard.SemiBold.size20)
                        Spacer()
                    }
                }
                .padding(.leading)
                
                Divider()
                    .frame(height: 60)
                    .background(Color.myD5D5D5)
                
                VStack(spacing: 10) {
                    HStack {
                        Text("내가 모은 클로버")
                            .font(.Pretendard.Medium.size15)
                        Spacer()
                    }
                    HStack {
                        Image(systemName: "star.fill")
                        
                        Text("16")
                            .font(.Pretendard.SemiBold.size20)
                        Spacer()
                    }
                }
                .padding(.leading)
                
                // ⚠️⚠️ 추가 구현
            }
            .frame(maxWidth: .infinity)
            .frame(height: 82)
            .background(.white)
            .cornerRadius(12)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.myF0E8DF, lineWidth: 1)
            )
            .padding(.top, 5)
        }
        .padding()
    }
}

#Preview {
    StatisticView()
}
