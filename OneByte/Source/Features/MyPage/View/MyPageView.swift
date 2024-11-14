//
//  MyPageView.swift
//  OneByte
//
//  Created by 트루디 on 10/17/24.
//

import SwiftUI
import SwiftData

struct MyPageView: View {
    
    @Query private var profile: [Profile]
    
    @State private var isEditNicknameSheet = false // 닉네임 변경 Sheet
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.myFFFAF4
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack {
                        headerView() // 최상단 헤더
                        
                        profileInfoView() // 유저 프로필 정보
                        
                        thisYearCloverInfoView() // 올해의 클로버
                        
                        Spacer()
                    }
                }
            }
        }
        .sheet(isPresented: $isEditNicknameSheet) {
            EditNicknameSheetView(isPresented: $isEditNicknameSheet)
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(244/852 * UIScreen.main.bounds.height)])
        }
    }
    
    @ViewBuilder
    private func headerView() -> some View {
        HStack {
            Text("마이페이지")
                .font(.Pretendard.Bold.size22)
                .foregroundStyle(Color.my9E9E9E)
            
            Spacer()
            
            NavigationLink {
                SettingView()
            } label: {
                Image(systemName: "gear")
                    .resizable()
                    .frame(width: 24, height: 23)
                    .foregroundStyle(Color.my9E9E9E)
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func profileInfoView() -> some View {
        VStack {
            HStack(spacing: 20) {
                Image("Turtle_3")
                    .resizable()
                    .background(.yellow)
                    .clipShape(Circle())
                    .frame(width: 82, height: 82)
                
                VStack(spacing: 5) {
                    HStack {
                        Text("\(profile.first?.nickName.isEmpty == false ? "\(profile.first!.nickName)님" : "닉네임 설정")")
                            .font(.Pretendard.Bold.size18)
                            .lineLimit(1)
                        
                        Image(systemName: "chevron.right")
                            .font(.Pretendard.Medium.size16)
                            .foregroundStyle(.black)
                        
                        Spacer()
                    }
                    .onTapGesture {
                        isEditNicknameSheet = true
                    }
                    
                    HStack {
                        Text("하고만다와 함께한지 50일 째")
                            .font(.Pretendard.SemiBold.size14)
                            .foregroundStyle(Color.my566956)
                        Spacer()
                    }
                }
            }
            .padding()
            
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.myEAEDE1)
                .frame(maxWidth: .infinity)
                .frame(height: 72)
                .overlay(alignment: .center) {
                    Text("황글 클로버 5개와 일반 클로버 16개, 총 21개의 클로버를 모아 여정이 한층 빛나고 있어요!")
                        .font(.Pretendard.Medium.size16)
                        .padding(5)
                }
                .padding(.horizontal)
        }
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
        .padding(.top, 10)
    }
}

#Preview {
    MyPageView()
}
