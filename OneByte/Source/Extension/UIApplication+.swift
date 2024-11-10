//
//  UIApplication.swift
//  OneByte
//
//  Created by 이상도 on 11/10/24.
//

import SwiftUI

extension UIApplication {
    // Keyboard가 올라와있을때, 빈 화면 터치 시 Keyboard 내려가는 함수
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
