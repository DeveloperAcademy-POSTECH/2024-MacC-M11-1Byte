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
                value: isActive.wrappedValue,
                label: { EmptyView() }
            )
            .navigationDestination(isPresented: isActive) {
                destination()
            }
            .hidden() // 숨김 처리
        )
    }
    
    func snapshot() -> UIImage {
        let targetSize = CGSize(width: UIScreen.main.bounds.width, height: 570/852 * UIScreen.main.bounds.height)
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        // 크기 및 프레임 설정
        view?.bounds = CGRect(origin: .zero, size: targetSize)
        view?.frame = CGRect(origin: .zero, size: targetSize)
        view?.backgroundColor = .clear

        // 캡처 실행
        let renderer = UIGraphicsImageRenderer(size: targetSize)
        return renderer.image { _ in
            view?.drawHierarchy(in: view?.bounds ?? CGRect.zero, afterScreenUpdates: true)
        }
    }

}
