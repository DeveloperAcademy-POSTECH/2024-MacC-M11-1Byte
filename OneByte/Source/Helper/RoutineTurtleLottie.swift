//
//  RoutineTurtleLottie.swift
//  OneByte
//
//  Created by 이상도 on 12/3/24.
//

import Foundation
import SwiftUI
import Lottie
import UIKit

public struct RoutineTurtleLottie: View {
    
    public let lottie: LottieAnimationType
    public let loopMode: LottieLoopMode
    public let speed: CGFloat
    public enum LottieAnimationType: String {
        case congratulations
        internal var filename: String {
            switch self {
            case .congratulations:
                "Congratulations"
            }
        }
    }
    public init(_ lottie: LottieAnimationType, loopMode: LottieLoopMode = .loop, speed: CGFloat = 1.0) {
        self.lottie = lottie
        self.loopMode = loopMode
        self.speed = speed
    }
    public var body: some View {
        LottieView(animation: .named(lottie.filename, bundle: .main))
            .configure({ lottieView in
                lottieView.animationSpeed = speed
                lottieView.loopMode = loopMode
            })
            .playing()
    }
}

#Preview {
    RoutineTurtleLottie(.congratulations, loopMode: .loop, speed: 1.0)
}
