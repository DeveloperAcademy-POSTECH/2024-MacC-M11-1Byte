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
    
    var body: some View {
        ZStack {
            Color.myFFFAF4
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 30) { // 전체 스택
                    HStack(alignment: .center) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("달성 표시하기")
                                .font(.Pretendard.Medium.size16)
                            Text("활성화 시 메인뷰에서 달성 여부를 편하게 볼 수 있어요.")
                                .font(.Pretendard.Medium.size12)
                                .foregroundStyle(Color(hex: "595959"))
                        }
                        Spacer()
                        Toggle("", isOn: $isAppearAchieved) // 레이블을 비워서 오른쪽 정렬
                            .labelsHidden() // Toggle의 레이블 숨기기
                    }
                    .padding(.horizontal)
                    
                    NavigationLink {
                        // 알림 설정 페이지
                    } label: {
                        HStack {
                            Text("알림 설정")
                                .font(.Pretendard.Medium.size16)
                                .foregroundStyle(.black)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    NavigationLink {
                        // 폰트 선택 페이지
                    } label: {
                        HStack {
                            Text("폰트 선택")
                                .font(.Pretendard.Medium.size16)
                                .foregroundStyle(.black)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    Divider()
                        .frame(height: 6)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "F0E8DF"))
                    
                    NavigationLink {
                        // 개인정보 처리 방침 페이지
                    } label: {
                        HStack {
                            Text("개인정보 처리 방침")
                                .font(.Pretendard.Medium.size16)
                                .foregroundStyle(.black)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    NavigationLink {
                        // 이용 약관 페이지
                    } label: {
                        HStack {
                            Text("이용 약관")
                                .font(.Pretendard.Medium.size16)
                                .foregroundStyle(.black)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    NavigationLink {
                        // 질문하기 페이지
                    } label: {
                        HStack {
                            Text("질문하기")
                                .font(.Pretendard.Medium.size16)
                                .foregroundStyle(.black)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    NavigationLink {
                        // 앱 버전 페이지
                    } label: {
                        HStack {
                            Text("앱 버전")
                                .font(.Pretendard.Medium.size16)
                                .foregroundStyle(.black)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                }
                .padding(.top)
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                    .tint(.black)
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
