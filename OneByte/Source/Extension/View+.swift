//
//  View+.swift
//  OneByte
//
//  Created by 트루디 on 11/15/24.
//

import SwiftUI

struct LazyView<Content: View>: View {
    let content: () -> Content
    var body: some View {
        content()
    }
}

extension View {
    func backButtonToolbar(action: @escaping () -> Void) -> some View {
        self.modifier(BackButtonToolbarModifier(action: action))
    }
    
    func navigationLink<T: View>(isActive: Binding<Bool>, destination: @escaping () -> T) -> some View {
        background(
            NavigationLink(
                destination: LazyView(content: destination),
                isActive: isActive,
                label: { EmptyView() }
            )
            .hidden() // Make the NavigationLink invisible
        )
    }
}
