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
    
    @State private var nickname: String = UserDefaults.loadNickname()

    var body: some View {
        NavigationStack {
            ZStack {
                Color.myF0E8DF
                    .ignoresSafeArea(edges: .bottom)
                
                ScrollView {
//                    HStack {
//                        profileInfoView()
//                    }
//                    .padding()
//                    .background(.white)
                    
                    VStack {
                        Divider()
                            .foregroundStyle(.clear)
                        
                        //                        AchievedRow(isAppearAchieved: $viewModel.isAppearAchieved)
                        
                        //                        Divider()
                        //                            .foregroundStyle(Color.myF0E8DF)
                        
                        Button {
                            viewModel.openAppSettings()
                        } label: {
                            HStack {
                                Text("알림 설정")
                                    .font(.setPretendard(weight: .semiBold, size: 16))
                                    .foregroundStyle(.black)
                                Spacer()
                            }
                            .padding()
                        }
                        
                        Divider()
                            .foregroundStyle(Color.myF0E8DF)
                        
                        //                        NavigationLink(destination: Text("폰트 선택")) {
                        //                            FontRow()
                        //                                .foregroundStyle(.black)
                        //                        }
                        //                        Divider()
                        //                            .foregroundStyle(.clear)
                    }
                    .background(.white)
                    
                    //                    VStack {
                    //                        Divider()
                    //                            .foregroundStyle(.clear)
                    //
                    //                        NavigationLink(destination: Text("개인정보 처리 방침")) {
                    //                            PrivacyPolicyRow()
                    //                                .foregroundStyle(.black)
                    //                        }
                    //                        Divider()
                    //                            .foregroundStyle(Color.myF0E8DF)
                    //
                    //                        NavigationLink(destination: Text("이용 약관")) {
                    //                            TermsRow()
                    //                                .foregroundStyle(.black)
                    //                        }
                    //                        Divider()
                    //                            .foregroundStyle(.clear)
                    //                    }
                    //                    .background(.white)
                    
                    HStack {
                        Text("Version \(viewModel.appVersion)") // 앱 버전정보
                            .font(.setPretendard(weight: .medium, size: 16))
                            .foregroundStyle(.myB4A99D)
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
            viewModel.getDaysSinceInstall() // 앱 설치한지 몇일 됐는지 계산
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
                    let nickname = UserDefaults.loadNickname()
                    if !nickname.isEmpty {
                        Text("\(nickname)님")
                            .font(.setPretendard(weight: .bold, size: 18))
                            .lineLimit(1)
                    } else {
                        Text("닉네임 설정")
                            .font(.setPretendard(weight: .bold, size: 18))
                    }
                    
                    Image(systemName: "chevron.right")
                        .font(.setPretendard(weight: .medium, size: 16))
                        .foregroundStyle(.black)
                    
                    Spacer()
                }
                .onTapGesture {
                    viewModel.isEditNicknameSheet = true
                }
                
                HStack {
                    Text("하고만다와 함께한지 \(viewModel.daysSinceInstall)일 째")
                        .font(.setPretendard(weight: .semiBold, size: 14))
                        .foregroundStyle(.my566956)
                    Spacer()
                }
            }
        }
        .padding(.vertical, 5)
    }
}

extension UserDefaults {
    private static let nicknameKey = "nicknameKey"
    private static let deviceUUIDKey = "deviceUUIDKey"
    
    static let calendarData = [
        // 2024년 ( 연도 / 월 / 월차 / 주차 / 클로버 스테이트 0 )
        (2024, 11, 1, 45, 0), (2024, 11, 2, 46, 0), (2024, 11, 3, 47, 0), (2024, 11, 4, 48, 0),
        (2024, 12, 1, 49, 0), (2024, 12, 2, 50, 0), (2024, 12, 3, 51, 0), (2024, 12, 4, 52, 0),
        // 2025년
        (2025, 1, 1, 1, 0), (2025, 1, 2, 2, 0), (2025, 1, 3, 3, 0), (2025, 1, 4, 4, 0), (2025, 1, 5, 5, 0),
        (2025, 2, 1, 6, 0), (2025, 2, 2, 7, 0), (2025, 2, 3, 8, 0), (2025, 2, 4, 9, 0),
        (2025, 3, 1, 10, 0), (2025, 3, 2, 11, 0), (2025, 3, 3, 12, 0), (2025, 3, 4, 13, 0),
        (2025, 4, 1, 14, 0), (2025, 4, 2, 15, 0), (2025, 4, 3, 16, 0), (2025, 4, 4, 17, 0),
        (2025, 5, 1, 18, 0), (2025, 5, 2, 19, 0), (2025, 5, 3, 20, 0), (2025, 5, 4, 21, 0), (2025, 5, 5, 22, 0),
        (2025, 6, 1, 23, 0), (2025, 6, 2, 24, 0), (2025, 6, 3, 25, 0), (2025, 6, 4, 26, 0),
        (2025, 7, 1, 27, 0), (2025, 7, 2, 28, 0), (2025, 7, 3, 29, 0), (2025, 7, 4, 30, 0), (2025, 7, 5, 31, 0),
        (2025, 8, 1, 32, 0), (2025, 8, 2, 33, 0), (2025, 8, 3, 34, 0), (2025, 8, 4, 35, 0),
        (2025, 9, 1, 36, 0), (2025, 9, 2, 37, 0), (2025, 9, 3, 38, 0), (2025, 9, 4, 39, 0),
        (2025, 10, 1, 40, 0), (2025, 10, 2, 41, 0), (2025, 10, 3, 42, 0), (2025, 10, 4, 43, 0), (2025, 10, 5, 44, 0),
        (2025, 11, 1, 45, 0), (2025, 11, 2, 46, 0), (2025, 11, 3, 47, 0), (2025, 11, 4, 48, 0),
        (2025, 12, 1, 49, 0), (2025, 12, 2, 50, 0), (2025, 12, 3, 51, 0), (2025, 12, 4, 52, 0),
        // 2026년
        (2026, 1, 1, 1, 0), (2026, 1, 2, 2, 0), (2026, 1, 4, 3, 0), (2026, 1, 3, 4, 0), (2026, 1, 5, 5, 0),
        (2026, 2, 1, 6, 0), (2026, 2, 2, 7, 0), (2026, 2, 4, 8, 0), (2026, 2, 3, 9, 0),
        (2026, 3, 1, 10, 0), (2026, 3, 2, 11, 0), (2026, 3, 4, 12, 0), (2026, 3, 3, 13, 0),
        (2026, 4, 1, 14, 0), (2026, 4, 2, 15, 0), (2026, 4, 4, 16, 0), (2026, 4, 3, 17, 0), (2026, 4, 5, 18, 0),
        (2026, 5, 1, 19, 0), (2026, 5, 2, 20, 0), (2026, 5, 4, 21, 0), (2026, 5, 3, 22, 0),
        (2026, 6, 1, 23, 0), (2026, 6, 2, 24, 0), (2026, 6, 4, 25, 0), (2026, 6, 3, 26, 0),
        (2026, 7, 1, 27, 0), (2026, 7, 2, 28, 0), (2026, 7, 4, 29, 0), (2026, 7, 3, 30, 0), (2026, 7, 5, 31, 0),
        (2026, 8, 1, 32, 0), (2026, 8, 2, 33, 0), (2026, 8, 4, 34, 0), (2026, 8, 3, 35, 0),
        (2026, 9, 1, 36, 0), (2026, 9, 2, 37, 0), (2026, 9, 4, 38, 0), (2026, 9, 3, 39, 0),
        (2026, 10, 1, 40, 0), (2026, 10, 2, 41, 0), (2026, 10, 4, 42, 0), (2026, 10, 3, 43, 0), (2026, 10, 5, 44, 0),
        (2026, 11, 1, 45, 0), (2026, 11, 2, 46, 0), (2026, 11, 4, 47, 0), (2026, 11, 3, 48, 0),
        (2026, 12, 1, 49, 0), (2026, 12, 2, 50, 0), (2026, 12, 4, 51, 0), (2026, 12, 3, 52, 0), (2026, 12, 5, 53, 0)
    ]
    
    // 닉네임 저장
    static func saveNickname(_ nickname: String) {
        UserDefaults.standard.set(nickname, forKey: nicknameKey)
    }
    
    // 닉네임 불러오기
    static func loadNickname() -> String {
        return UserDefaults.standard.string(forKey: nicknameKey) ?? ""
    }
    
    static func saveDeviceUUID() {
        if UserDefaults.standard.string(forKey: deviceUUIDKey) == nil {
            let uuid = UUID().uuidString
            UserDefaults.standard.set(uuid, forKey: deviceUUIDKey)
            print("✅ UUID 저장 완료: \(uuid)")
        }
    }

    static func loadDeviceUUID() -> String {
        let uuid = UserDefaults.standard.string(forKey: deviceUUIDKey) ?? "None"
        print("📤 UUID 불러오기: \(uuid)")
        return uuid
    }
        
    static func loadInstallYear() -> Int? {
        guard let installDateString = UserDefaults.standard.string(forKey: "userInstallDate") else {
            print("❌ userInstallDate을 찾을 수 없습니다")
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        guard let installDate = formatter.date(from: installDateString) else {
            print("❌ userInstallDate를 Date 객체로 변환하는 데 실패했습니다.")
            return nil
        }
        
        let calendar = Calendar(identifier: .iso8601)
        let year = calendar.component(.year, from: installDate)
        return year
    }
    
    static func loadInstallMonth() -> Int? {
        guard let installDateString = UserDefaults.standard.string(forKey: "userInstallDate") else {
            print("❌ userInstallDate을 찾을 수 없습니다")
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        guard let installDate = formatter.date(from: installDateString) else {
            print("❌ userInstallDate를 Date 객체로 변환하는 데 실패했습니다.")
            return nil
        }
        
        let calendar = Calendar(identifier: .iso8601)
        let weekOfYear = calendar.component(.weekOfYear, from: installDate)
        let year = calendar.component(.year, from: installDate)
        
        if let data = calendarData.first(where: { $0.0 == year && $0.3 == weekOfYear }) {
            return data.1
        }
        return calendar.component(.month, from: Date())
    }
    
    static func loadInstallWeekOfYear() -> Int? {
        guard let installDateString = UserDefaults.standard.string(forKey: "userInstallDate") else {
            print("❌ userInstallDate을 찾을 수 없습니다.")
            return nil
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        guard let installDate = formatter.date(from: installDateString) else {
            print("❌ userInstallDate을 Date 객체로 변환하는 데 실패했습니다.")
            return nil
        }
        
        let calendar = Calendar(identifier: .iso8601)
        let weekOfYear = calendar.component(.weekOfYear, from: installDate)
        return weekOfYear
    }
}

#Preview {
    SettingView(isTabBarMainVisible: .constant(true))
}
