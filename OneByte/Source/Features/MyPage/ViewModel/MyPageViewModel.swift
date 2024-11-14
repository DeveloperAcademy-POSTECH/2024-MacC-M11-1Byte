//
//  MyPageViewModel.swift
//  OneByte
//
//  Created by 이상도 on 11/14/24.
//

import SwiftUI
import SwiftData

class MyPageViewModel: ObservableObject {
    
    @Published var profile: [Profile] = []
    @Published var newNickname: String = ""
    
    let nicknameLimit = 10
    
    func updateProfile(_ profile: [Profile]) {
        self.profile = profile
        if let nickName = profile.first?.nickName {
            newNickname = nickName
        }
    }
    
    // 마이페이지 닉네임View 조건 처리 로직
    var nicknameDisplay: String {
        if let nickName = profile.first?.nickName, !nickName.isEmpty {
            return "\(nickName)님"
        } else {
            return "닉네임 설정"
        }
    }
    
    // 닉네임 변경중 타이핑 닉네임 비우기
    func clearNewNickname() {
        newNickname = ""
    }
    
    // 닉네임 Update
    func updateNewNickname(modelContext: ModelContext) {
        if let existingProfile = profile.first {
            existingProfile.nickName = newNickname
        } else {
            // 만약 닉네임이 없을경우, 새로 생성
            let newProfile = Profile(nickName: newNickname)
            modelContext.insert(newProfile)
            profile.append(newProfile)
        }
        
        do {
            try modelContext.save()
            print("닉네임 저장 성공")
        } catch {
            print("닉네임 저장 실패: \(error)")
        }
    }
}
