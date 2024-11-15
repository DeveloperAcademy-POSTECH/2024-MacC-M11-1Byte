//
//  SettingView.swift
//  OneByte
//
//  Created by 이상도 on 11/14/24.
//

import SwiftUI

struct SettingView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State var viewModel = SettingViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "F0E8DF")
                    .ignoresSafeArea(edges: .bottom)
                
                ScrollView {
                    VStack {
                        Divider()
                            .foregroundStyle(Color.clear)
                        
                        AchievedRow(isAppearAchieved: $viewModel.isAppearAchieved)
                        
                        Divider()
                            .foregroundStyle(Color(hex: "F0E8DF"))
                        
                        NavigationLink(destination: Text("알림 설정 화면")) {
                            NotificationRow()
                                .foregroundStyle(.black)
                        }
                        Divider()
                            .foregroundStyle(Color(hex: "F0E8DF"))
                        
                        NavigationLink(destination: Text("폰트 선택")) {
                            FontRow()
                                .foregroundStyle(.black)
                        }
                        Divider()
                            .foregroundStyle(Color.clear)
                    }
                    .background(.white)
                    
                    VStack {
                        Divider()
                            .foregroundStyle(Color.clear)
                        
                        NavigationLink(destination: Text("개인정보 처리 방침")) {
                            PrivacyPolicyRow()
                                .foregroundStyle(.black)
                        }
                        Divider()
                            .foregroundStyle(Color(hex: "F0E8DF"))
                        
                        NavigationLink(destination: Text("이용 약관")) {
                            TermsRow()
                                .foregroundStyle(.black)
                        }
                        Divider()
                            .foregroundStyle(Color.clear)
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
                .navigationTitle("설정")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .backButtonToolbar {
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
