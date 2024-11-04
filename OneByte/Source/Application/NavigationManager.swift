//
//  NavigationManager.swift
//  OneByte
//
//  Created by 이상도 on 11/2/24.
//

import SwiftUI

enum PathType: Hashable {
    case main
    case total
    case select
    case retrospect
    case complete
}

extension PathType {
    @ViewBuilder
    func NavigatingView() -> some View {
        switch self {
        case .main:
            RetrospectMainView()
                .navigationBarBackButtonHidden()
            
        case .total:
            RetrospectTotalView()
                .navigationBarBackButtonHidden()
            
        case .select:
            RetrospectSelectView()
                .navigationBarBackButtonHidden()
            
        case .retrospect:
            RetrospectView()
                .navigationBarBackButtonHidden()
            
        case .complete:
            RetrospectCompleteView()
                .navigationBarBackButtonHidden()
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
