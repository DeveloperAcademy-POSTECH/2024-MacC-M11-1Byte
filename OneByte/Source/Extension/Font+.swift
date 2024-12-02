//
//  Font+.swift
//  OneByte
//
//  Created by 이상도 on 11/9/24.
//

import SwiftUI

extension Font {
    /// Black / ExtraBold / Bold / SemiBold / Medium / Regular / Light / ExtraLight / Thin
    enum Pretendard {
        
        enum Black {
            static let size8: Font = .custom("Pretendard-Black", size: 8)
            static let size10: Font = .custom("Pretendard-Black", size: 10)
            static let size12: Font = .custom("Pretendard-Black", size: 12)
            static let size14: Font = .custom("Pretendard-Black", size: 14)
            static let size16: Font = .custom("Pretendard-Black", size: 16)
            static let size18: Font = .custom("Pretendard-Black", size: 18)
            static let size20: Font = .custom("Pretendard-Black", size: 20)
            static let size22: Font = .custom("Pretendard-Black", size: 22)
            static let size24: Font = .custom("Pretendard-Black", size: 24)
            static let size26: Font = .custom("Pretendard-Black", size: 26)
            static let size28: Font = .custom("Pretendard-Black", size: 28)
        }
        
        enum ExtraBold {
            static let size8: Font = .custom("Pretendard-ExtraBold", size: 8)
            static let size10: Font = .custom("Pretendard-ExtraBold", size: 10)
            static let size12: Font = .custom("Pretendard-ExtraBold", size: 12)
            static let size14: Font = .custom("Pretendard-ExtraBold", size: 14)
            static let size16: Font = .custom("Pretendard-ExtraBold", size: 16)
            static let size18: Font = .custom("Pretendard-ExtraBold", size: 18)
            static let size20: Font = .custom("Pretendard-ExtraBold", size: 20)
            static let size22: Font = .custom("Pretendard-ExtraBold", size: 22)
            static let size24: Font = .custom("Pretendard-ExtraBold", size: 24)
            static let size26: Font = .custom("Pretendard-ExtraBold", size: 26)
            static let size28: Font = .custom("Pretendard-ExtraBold", size: 28)
        }
        
        enum Bold {
            static let size8: Font = .custom("Pretendard-Bold", size: 8)
            static let size10: Font = .custom("Pretendard-Bold", size: 10)
            static let size12: Font = .custom("Pretendard-Bold", size: 12)
            static let size13: Font = .custom("Pretendard-Bold", size: 13)
            static let size14: Font = .custom("Pretendard-Bold", size: 14)
            static let size16: Font = .custom("Pretendard-Bold", size: 16)
            static let size17: Font = .custom("Pretendard-Bold", size: 17)
            static let size18: Font = .custom("Pretendard-Bold", size: 18)
            static let size20: Font = .custom("Pretendard-Bold", size: 20)
            static let size22: Font = .custom("Pretendard-Bold", size: 22)
            static let size24: Font = .custom("Pretendard-Bold", size: 24)
            static let size26: Font = .custom("Pretendard-Bold", size: 26)
            static let size28: Font = .custom("Pretendard-Bold", size: 28)
        }
        
        enum SemiBold {
            static let size8: Font = .custom("Pretendard-SemiBold", size: 8)
            static let size10: Font = .custom("Pretendard-SemiBold", size: 10)
            static let size12: Font = .custom("Pretendard-SemiBold", size: 12)
            static let size13: Font = .custom("Pretendard-SemiBold", size: 13)
            static let size14: Font = .custom("Pretendard-SemiBold", size: 14)
            static let size16: Font = .custom("Pretendard-SemiBold", size: 16)
            static let size17: Font = .custom("Pretendard-SemiBold", size: 17)
            static let size18: Font = .custom("Pretendard-SemiBold", size: 18)
            static let size20: Font = .custom("Pretendard-SemiBold", size: 20)
            static let size22: Font = .custom("Pretendard-SemiBold", size: 22)
            static let size24: Font = .custom("Pretendard-SemiBold", size: 24)
            static let size26: Font = .custom("Pretendard-SemiBold", size: 26)
            static let size28: Font = .custom("Pretendard-SemiBold", size: 28)
            static let size40: Font = .custom("Pretendard-SemiBold", size: 40)
        }
        
        enum Medium {
            static let size8: Font = .custom("Pretendard-Medium", size: 8)
            static let size10: Font = .custom("Pretendard-Medium", size: 10)
            static let size11: Font = .custom("Pretendard-Medium", size: 11)
            static let size12: Font = .custom("Pretendard-Medium", size: 12)
            static let size13: Font = .custom("Pretendard-Medium", size: 13)
            static let size14: Font = .custom("Pretendard-Medium", size: 14)
            static let size15: Font = .custom("Pretendard-Medium", size: 15)
            static let size16: Font = .custom("Pretendard-Medium", size: 16)
            static let size17: Font = .custom("Pretendard-Medium", size: 17)
            static let size18: Font = .custom("Pretendard-Medium", size: 18)
            static let size20: Font = .custom("Pretendard-Medium", size: 20)
            static let size22: Font = .custom("Pretendard-Medium", size: 22)
            static let size24: Font = .custom("Pretendard-Medium", size: 24)
            static let size26: Font = .custom("Pretendard-Medium", size: 26)
            static let size28: Font = .custom("Pretendard-Medium", size: 28)
        }
        
        enum Regular {
            static let size8: Font = .custom("Pretendard-Regular", size: 8)
            static let size10: Font = .custom("Pretendard-Regular", size: 10)
            static let size12: Font = .custom("Pretendard-Regular", size: 12)
            static let size13: Font = .custom("Pretendard-Regular", size: 13)
            static let size14: Font = .custom("Pretendard-Regular", size: 14)
            static let size16: Font = .custom("Pretendard-Regular", size: 16)
            static let size17: Font = .custom("Pretendard-Regular", size: 17)
            static let size18: Font = .custom("Pretendard-Regular", size: 18)
            static let size20: Font = .custom("Pretendard-Regular", size: 20)
            static let size22: Font = .custom("Pretendard-Regular", size: 22)
            static let size24: Font = .custom("Pretendard-Regular", size: 24)
            static let size26: Font = .custom("Pretendard-Regular", size: 26)
            static let size28: Font = .custom("Pretendard-Regular", size: 28)
        }
        
        enum Light {
            static let size8: Font = .custom("Pretendard-Light", size: 8)
            static let size10: Font = .custom("Pretendard-Light", size: 10)
            static let size12: Font = .custom("Pretendard-Light", size: 12)
            static let size14: Font = .custom("Pretendard-Light", size: 14)
            static let size16: Font = .custom("Pretendard-Light", size: 16)
            static let size17: Font = .custom("Pretendard-Light", size: 17)
            static let size18: Font = .custom("Pretendard-Light", size: 18)
            static let size20: Font = .custom("Pretendard-Light", size: 20)
            static let size22: Font = .custom("Pretendard-Light", size: 22)
            static let size24: Font = .custom("Pretendard-Light", size: 24)
            static let size26: Font = .custom("Pretendard-Light", size: 26)
            static let size28: Font = .custom("Pretendard-Light", size: 28)
        }
        
        enum ExtraLight {
            static let size8: Font = .custom("Pretendard-ExtraLight", size: 8)
            static let size10: Font = .custom("Pretendard-ExtraLight", size: 10)
            static let size12: Font = .custom("Pretendard-ExtraLight", size: 12)
            static let size14: Font = .custom("Pretendard-ExtraLight", size: 14)
            static let size16: Font = .custom("Pretendard-ExtraLight", size: 16)
            static let size18: Font = .custom("Pretendard-ExtraLight", size: 18)
            static let size20: Font = .custom("Pretendard-ExtraLight", size: 20)
            static let size22: Font = .custom("Pretendard-ExtraLight", size: 22)
            static let size24: Font = .custom("Pretendard-ExtraLight", size: 24)
            static let size26: Font = .custom("Pretendard-ExtraLight", size: 26)
            static let size28: Font = .custom("Pretendard-ExtraLight", size: 28)
        }
        
        enum Thin {
            static let size8: Font = .custom("Pretendard-Thin", size: 8)
            static let size10: Font = .custom("Pretendard-Thin", size: 10)
            static let size12: Font = .custom("Pretendard-Thin", size: 12)
            static let size14: Font = .custom("Pretendard-Thin", size: 14)
            static let size16: Font = .custom("Pretendard-Thin", size: 16)
            static let size18: Font = .custom("Pretendard-Thin", size: 18)
            static let size20: Font = .custom("Pretendard-Thin", size: 20)
            static let size22: Font = .custom("Pretendard-Thin", size: 22)
            static let size24: Font = .custom("Pretendard-Thin", size: 24)
            static let size26: Font = .custom("Pretendard-Thin", size: 26)
            static let size28: Font = .custom("Pretendard-Thin", size: 28)
        }
    }
}
