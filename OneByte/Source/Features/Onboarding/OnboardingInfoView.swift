//
//  OnboardingInfoView.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

struct OnboardingInfoView: View {
    
    @Environment(NavigationManager.self) var navigationManager
    
    var body: some View {
        VStack {
            Text("Hello, World!")
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    navigationManager.pop()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                            .tint(.black)
                            .bold()
                    }
                }
            }
        }
    }
}

#Preview {
    OnboardingInfoView()
        .environment(NavigationManager())
}
