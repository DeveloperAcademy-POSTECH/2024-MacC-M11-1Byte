//
//  RetrospectTotalView.swift
//  OneByte
//
//  Created by 이상도 on 11/4/24.
//

import SwiftUI

struct RetrospectTotalView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    
    var body: some View {
        Text("Hello, World!")
    }
}

#Preview {
    RetrospectTotalView()
        .environment(NavigationManager())
}
