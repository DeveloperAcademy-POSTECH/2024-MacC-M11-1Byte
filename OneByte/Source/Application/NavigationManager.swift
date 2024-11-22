//
//  NavigationManager.swift
//  OneByte
//
//  Created by 이상도 on 11/2/24.
//

import SwiftUI

enum PathType: Hashable {
    // 온보딩 case
    case onboardStart
    case onboardReady
    case onboardSubgoal
    case onboardDetailgoal
    case onboardDays
//    case onboardQuestion
//    case onboardMaingoal
//    case onboardSubgoal
//    case onboardDetailgoal
//    case onboardFinish
//    case onboardInfo
}

extension PathType {
    @ViewBuilder
    func NavigatingView() -> some View {
        switch self {
        // 온보딩 case
        case .onboardStart:
            OnboardingStartView()
            
        case .onboardReady:
            ReadyCycleView()
            
        case .onboardSubgoal:
            EnterSubgoalView() // SubgoalCycleView로 이름 변경
            
        case .onboardDetailgoal:
            EnterDetailgoalView()
            
        case .onboardDays:
            DaysCycleView()
            
//        case .onboardQuestion:
//            QuestionView()
//                .navigationBarBackButtonHidden()
//                .navigationBarHidden(true)
//            
//        case .onboardMaingoal:
//            EnterMaingoalView()
//                .navigationBarBackButtonHidden()
//                .navigationBarHidden(true)
//            
//        case .onboardSubgoal:
//            EnterSubgoalView()
//                .navigationBarBackButtonHidden()
//                .navigationBarHidden(true)
//            
//        case .onboardDetailgoal:
//            EnterDetailgoalView()
//                .navigationBarBackButtonHidden()
//                .navigationBarHidden(true)
//            
//        case .onboardFinish:
//            OnboardingFinishView()
//                .navigationBarBackButtonHidden()
//            
//        case .onboardInfo:
//            OnboardingExplainView()
//                .navigationBarBackButtonHidden()
        }
    }
}

@Observable
class NavigationManager {
    var path: [PathType]
    init(
        path: [PathType] = []
    ){
        self.path = path
    }
}

extension NavigationManager {
    func push(to pathType: PathType) {
        path.append(pathType)
    }
    
    func pop() {
        path.removeLast()
    }
    
    func popToRoot() {
        path.removeAll()
    }
    
    func pop(to pathType: PathType) {
        guard let lastIndex = path.lastIndex(of: pathType) else { return }
        path.removeLast(path.count - (lastIndex + 1))
    }
}
