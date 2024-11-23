//
//  SettingView.swift
//  OneByte
//
//  Created by 이상도 on 11/14/24.
//

import SwiftUI
import SwiftData

struct SettingView: View {
    
    @Query private var profile: [Profile]
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel = SettingViewModel()
    @Binding var isTabBarMainVisible: Bool
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.myF0E8DF
                    .ignoresSafeArea(edges: .bottom)
                
                ScrollView {
                    HStack {
                        profileInfoView()
                    }
                    .padding()
                    .background(.white)
                    
                    VStack {
                        Divider()
                            .foregroundStyle(.clear)
                        
                        AchievedRow(isAppearAchieved: $viewModel.isAppearAchieved)
                        
                        Divider()
                            .foregroundStyle(Color.myF0E8DF)
                        
                        Button {
                            viewModel.openAppSettings()
                        } label: {
                            HStack {
                                Text("알림 설정")
                                    .font(.Pretendard.SemiBold.size16)
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            .padding()
                        }
                        
                        Divider()
                            .foregroundStyle(Color.myF0E8DF)
                        
                        NavigationLink(destination: Text("폰트 선택")) {
                            FontRow()
                                .foregroundStyle(.black)
                        }
                        Divider()
                            .foregroundStyle(.clear)
                    }
                    .background(.white)
                    
                    VStack {
                        Divider()
                            .foregroundStyle(.clear)
                        
                        NavigationLink(destination: Text("개인정보 처리 방침")) {
                            PrivacyPolicyRow()
                                .foregroundStyle(.black)
                        }
                        Divider()
                            .foregroundStyle(Color.myF0E8DF)
                        
                        NavigationLink(destination: Text("이용 약관")) {
                            TermsRow()
                                .foregroundStyle(.black)
                        }
                        Divider()
                            .foregroundStyle(.clear)
                    }
                    .background(.white)
                    
                    HStack {
                        Text("Version \(viewModel.appVersion)") // 앱 버전정보
                            .font(.Pretendard.Medium.size16)
                            .foregroundStyle(Color.myB4A99D)
                    }
                    .padding(.top, 30)
                    
                    Spacer()
                }
            }
        }
        .navigationTitle("설정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    self.viewModel.settingViewTabBarVisible = true
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .tint(Color.myB4A99D)
                }
            }
        }
        .toolbar(viewModel.settingViewTabBarVisible ? .visible : .hidden, for: .tabBar)
        .onAppear {
            isTabBarMainVisible = false
            viewModel.settingViewTabBarVisible = false // 첫 진입시 Tabbar 숨김
            viewModel.readProfile(profile) // 닉네임 정보
            viewModel.calculateDaysSinceInstall() // 앱 설치한지 몇일 됐는지 계산
        }
        .sheet(isPresented: $viewModel.isEditNicknameSheet) {
            EditNicknameSheetView(viewModel: viewModel)
                .presentationDragIndicator(.visible)
                .presentationDetents([.height(244/852 * UIScreen.main.bounds.height)])
        }
    }
    
    @ViewBuilder
    private func profileInfoView() -> some View {
        HStack(spacing: 20) {
            Image("DefaultProfile")
                .resizable()
                .clipShape(Circle())
                .frame(width: 82, height: 82)
            
            VStack(spacing: 5) {
                HStack {
                    Text(viewModel.nicknameDisplay)
                        .font(.Pretendard.Bold.size18)
                        .lineLimit(1)
                    
                    Image(systemName: "chevron.right")
                        .font(.Pretendard.Medium.size16)
                        .foregroundStyle(.black)
                    
                    Spacer()
                }
                .onTapGesture {
                    viewModel.isEditNicknameSheet = true
                }
                
                HStack {
                    Text("하고만다와 함께한지 \(viewModel.daysSinceInstall)일 째")
                        .font(.Pretendard.SemiBold.size14)
                        .foregroundStyle(Color.my566956)
                    Spacer()
                }
            }
        }
        .padding(.vertical, 5)
    }
}

#Preview {
    SettingView(isTabBarMainVisible: .constant(true))
}
