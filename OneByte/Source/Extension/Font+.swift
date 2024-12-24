//
//  Font+.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

extension Font {
    /// Black / ExtraBold / Bold / SemiBold / Medium / Regular / Light / ExtraLight / Thin
    enum FontWeight: String {
        case black = "Pretendard-Black"
        case bold = "Pretendard-Bold"
        case extraBold = "Pretendard-ExtraBold"
        case extraLight = "Pretendard-ExtraLight"
        case light = "Pretendard-Light"
        case medium = "Pretendard-Medium"
        case regular = "Pretendard-Regular"
        case semiBold = "Pretendard-SemiBold"
        case thin = "Pretendard-Thin"
    }
    
    static func setPretendard(weight: FontWeight, size: CGFloat) -> Font {
        return .custom(weight.rawValue, fixedSize: size)
    }
}
