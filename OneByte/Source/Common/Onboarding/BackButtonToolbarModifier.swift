//
//  BackButtonToolbarModifier.swift
//  OneByte
//
//  Created by 트루디 on 11/15/24.
//

import SwiftUI

struct BackButtonToolbarModifier: ViewModifier {
    var action: () -> Void

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        action()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .tint(Color(hex: "B4A99D"))
                        }
                    }
                }
            }
    }
}

