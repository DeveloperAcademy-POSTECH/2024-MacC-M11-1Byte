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
    case onboardComplete
    case onboardFinish
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
            
        case .onboardComplete:
            CompleteCycleView()
            
        case .onboardFinish:
            OnboardingFinishView()
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
