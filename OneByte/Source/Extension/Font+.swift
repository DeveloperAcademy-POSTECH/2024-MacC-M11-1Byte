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
            static let size8: Font = .custom("Pretendard-Black", fixedSize: 8)
            static let size10: Font = .custom("Pretendard-Black", fixedSize: 10)
            static let size12: Font = .custom("Pretendard-Black", fixedSize: 12)
            static let size14: Font = .custom("Pretendard-Black", fixedSize: 14)
            static let size16: Font = .custom("Pretendard-Black", fixedSize: 16)
            static let size18: Font = .custom("Pretendard-Black", fixedSize: 18)
            static let size20: Font = .custom("Pretendard-Black", fixedSize: 20)
            static let size22: Font = .custom("Pretendard-Black", fixedSize: 22)
            static let size24: Font = .custom("Pretendard-Black", fixedSize: 24)
            static let size26: Font = .custom("Pretendard-Black", fixedSize: 26)
            static let size28: Font = .custom("Pretendard-Black", fixedSize: 28)
        }
        
        enum ExtraBold {
            static let size8: Font = .custom("Pretendard-ExtraBold", fixedSize: 8)
            static let size10: Font = .custom("Pretendard-ExtraBold", fixedSize: 10)
            static let size12: Font = .custom("Pretendard-ExtraBold", fixedSize: 12)
            static let size14: Font = .custom("Pretendard-ExtraBold", fixedSize: 14)
            static let size16: Font = .custom("Pretendard-ExtraBold", fixedSize: 16)
            static let size18: Font = .custom("Pretendard-ExtraBold", fixedSize: 18)
            static let size20: Font = .custom("Pretendard-ExtraBold", fixedSize: 20)
            static let size22: Font = .custom("Pretendard-ExtraBold", fixedSize: 22)
            static let size24: Font = .custom("Pretendard-ExtraBold", fixedSize: 24)
            static let size26: Font = .custom("Pretendard-ExtraBold", fixedSize: 26)
            static let size28: Font = .custom("Pretendard-ExtraBold", fixedSize: 28)
        }
        
        enum Bold {
            static let size8: Font = .custom("Pretendard-Bold", fixedSize: 8)
            static let size10: Font = .custom("Pretendard-Bold", fixedSize: 10)
            static let size12: Font = .custom("Pretendard-Bold", fixedSize: 12)
            static let size13: Font = .custom("Pretendard-Bold", fixedSize: 13)
            static let size14: Font = .custom("Pretendard-Bold", fixedSize: 14)
            static let size16: Font = .custom("Pretendard-Bold", fixedSize: 16)
            static let size17: Font = .custom("Pretendard-Bold", fixedSize: 17)
            static let size18: Font = .custom("Pretendard-Bold", fixedSize: 18)
            static let size20: Font = .custom("Pretendard-Bold", fixedSize: 20)
            static let size22: Font = .custom("Pretendard-Bold", fixedSize: 22)
            static let size24: Font = .custom("Pretendard-Bold", fixedSize: 24)
            static let size26: Font = .custom("Pretendard-Bold", fixedSize: 26)
            static let size28: Font = .custom("Pretendard-Bold", fixedSize: 28)
        }
        
        enum SemiBold {
            static let size8: Font = .custom("Pretendard-SemiBold", fixedSize: 8)
            static let size10: Font = .custom("Pretendard-SemiBold", fixedSize: 10)
            static let size12: Font = .custom("Pretendard-SemiBold", fixedSize: 12)
            static let size13: Font = .custom("Pretendard-SemiBold", fixedSize: 13)
            static let size14: Font = .custom("Pretendard-SemiBold", fixedSize: 14)
            static let size16: Font = .custom("Pretendard-SemiBold", fixedSize: 16)
            static let size17: Font = .custom("Pretendard-SemiBold", fixedSize: 17)
            static let size18: Font = .custom("Pretendard-SemiBold", fixedSize: 18)
            static let size20: Font = .custom("Pretendard-SemiBold", fixedSize: 20)
            static let size22: Font = .custom("Pretendard-SemiBold", fixedSize: 22)
            static let size24: Font = .custom("Pretendard-SemiBold", fixedSize: 24)
            static let size26: Font = .custom("Pretendard-SemiBold", fixedSize: 26)
            static let size28: Font = .custom("Pretendard-SemiBold", fixedSize: 28)
            static let size40: Font = .custom("Pretendard-SemiBold", fixedSize: 40)
        }
        
        enum Medium {
            static let size8: Font = .custom("Pretendard-Medium", fixedSize: 8)
            static let size10: Font = .custom("Pretendard-Medium", fixedSize: 10)
            static let size11: Font = .custom("Pretendard-Medium", fixedSize: 11)
            static let size12: Font = .custom("Pretendard-Medium", fixedSize: 12)
            static let size13: Font = .custom("Pretendard-Medium", fixedSize: 13)
            static let size14: Font = .custom("Pretendard-Medium", fixedSize: 14)
            static let size15: Font = .custom("Pretendard-Medium", fixedSize: 15)
            static let size16: Font = .custom("Pretendard-Medium", fixedSize: 16)
            static let size17: Font = .custom("Pretendard-Medium", fixedSize: 17)
            static let size18: Font = .custom("Pretendard-Medium", fixedSize: 18)
            static let size20: Font = .custom("Pretendard-Medium", fixedSize: 20)
            static let size22: Font = .custom("Pretendard-Medium", fixedSize: 22)
            static let size24: Font = .custom("Pretendard-Medium", fixedSize: 24)
            static let size26: Font = .custom("Pretendard-Medium", fixedSize: 26)
            static let size28: Font = .custom("Pretendard-Medium", fixedSize: 28)
        }
        
        enum Regular {
            static let size8: Font = .custom("Pretendard-Regular", fixedSize: 8)
            static let size10: Font = .custom("Pretendard-Regular", fixedSize: 10)
            static let size12: Font = .custom("Pretendard-Regular", fixedSize: 12)
            static let size13: Font = .custom("Pretendard-Regular", fixedSize: 13)
            static let size14: Font = .custom("Pretendard-Regular", fixedSize: 14)
            static let size16: Font = .custom("Pretendard-Regular", fixedSize: 16)
            static let size17: Font = .custom("Pretendard-Regular", fixedSize: 17)
            static let size18: Font = .custom("Pretendard-Regular", fixedSize: 18)
            static let size20: Font = .custom("Pretendard-Regular", fixedSize: 20)
            static let size22: Font = .custom("Pretendard-Regular", fixedSize: 22)
            static let size24: Font = .custom("Pretendard-Regular", fixedSize: 24)
            static let size26: Font = .custom("Pretendard-Regular", fixedSize: 26)
            static let size28: Font = .custom("Pretendard-Regular", fixedSize: 28)
        }
        
        enum Light {
            static let size8: Font = .custom("Pretendard-Light", fixedSize: 8)
            static let size10: Font = .custom("Pretendard-Light", fixedSize: 10)
            static let size12: Font = .custom("Pretendard-Light", fixedSize: 12)
            static let size14: Font = .custom("Pretendard-Light", fixedSize: 14)
            static let size16: Font = .custom("Pretendard-Light", fixedSize: 16)
            static let size17: Font = .custom("Pretendard-Light", fixedSize: 17)
            static let size18: Font = .custom("Pretendard-Light", fixedSize: 18)
            static let size20: Font = .custom("Pretendard-Light", fixedSize: 20)
            static let size22: Font = .custom("Pretendard-Light", fixedSize: 22)
            static let size24: Font = .custom("Pretendard-Light", fixedSize: 24)
            static let size26: Font = .custom("Pretendard-Light", fixedSize: 26)
            static let size28: Font = .custom("Pretendard-Light", fixedSize: 28)
        }
        
        enum ExtraLight {
            static let size8: Font = .custom("Pretendard-ExtraLight", fixedSize: 8)
            static let size10: Font = .custom("Pretendard-ExtraLight", fixedSize: 10)
            static let size12: Font = .custom("Pretendard-ExtraLight", fixedSize: 12)
            static let size14: Font = .custom("Pretendard-ExtraLight", fixedSize: 14)
            static let size16: Font = .custom("Pretendard-ExtraLight", fixedSize: 16)
            static let size18: Font = .custom("Pretendard-ExtraLight", fixedSize: 18)
            static let size20: Font = .custom("Pretendard-ExtraLight", fixedSize: 20)
            static let size22: Font = .custom("Pretendard-ExtraLight", fixedSize: 22)
            static let size24: Font = .custom("Pretendard-ExtraLight", fixedSize: 24)
            static let size26: Font = .custom("Pretendard-ExtraLight", fixedSize: 26)
            static let size28: Font = .custom("Pretendard-ExtraLight", fixedSize: 28)
        }
        
        enum Thin {
            static let size8: Font = .custom("Pretendard-Thin", fixedSize: 8)
            static let size10: Font = .custom("Pretendard-Thin", fixedSize: 10)
            static let size12: Font = .custom("Pretendard-Thin", fixedSize: 12)
            static let size14: Font = .custom("Pretendard-Thin", fixedSize: 14)
            static let size16: Font = .custom("Pretendard-Thin", fixedSize: 16)
            static let size18: Font = .custom("Pretendard-Thin", fixedSize: 18)
            static let size20: Font = .custom("Pretendard-Thin", fixedSize: 20)
            static let size22: Font = .custom("Pretendard-Thin", fixedSize: 22)
            static let size24: Font = .custom("Pretendard-Thin", fixedSize: 24)
            static let size26: Font = .custom("Pretendard-Thin", fixedSize: 26)
            static let size28: Font = .custom("Pretendard-Thin", fixedSize: 28)
        }
    }
}
