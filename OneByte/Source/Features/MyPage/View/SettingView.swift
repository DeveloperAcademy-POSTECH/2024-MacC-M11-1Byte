//
//  SettingView.swift
//  OneByte
//
//  Created by 이상도 on 11/14/24.
//

import SwiftUI

struct SettingView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var isAppearAchieved: Bool = false // 달성 표시하기
    
    @StateObject var viewModel = SettingViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "F0E8DF")
                    .ignoresSafeArea(edges: .bottom)
                
                ScrollView {
                    VStack {
                        Divider()
                            .foregroundStyle(Color.clear)
                        
                        AchievedRow(isAppearAchieved: $isAppearAchieved)
                        
                        Divider()
                            .foregroundStyle(Color(hex: "F0E8DF"))
                        
                        NavigationLink(destination: Text("알림 설정 화면")) {
                            NotificationRow()
                                .foregroundStyle(.black)
                        }
                        
                        Divider()
                            .foregroundStyle(Color(hex: "F0E8DF"))
                        
                        NavigationLink(destination: Text("폰트 선택 화면")) {
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
                        
                        NavigationLink(destination: Text("개인정보 처리 방침 화면")) {
                            PrivacyPolicyRow()
                                .foregroundStyle(.black)
                        }
                        
                        Divider()
                            .foregroundStyle(Color(hex: "F0E8DF"))
                        
                        NavigationLink(destination: Text("이용 약관 화면")) {
                            TermsRow()
                                .foregroundStyle(.black)
                        }
                        
                        Divider()
                            .foregroundStyle(Color.clear)
                    }
                    .background(.white)
                    
                    HStack {
                        Text("Version \(viewModel.appVersion)")
                            .font(.Pretendard.Medium.size16)
                            .foregroundStyle(Color.myB4A99D)
                    }
                    .padding(.top, 30)
                    
                    Spacer()
                }
                .navigationTitle("설정")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .tint(Color(hex: "B4A99D"))
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
