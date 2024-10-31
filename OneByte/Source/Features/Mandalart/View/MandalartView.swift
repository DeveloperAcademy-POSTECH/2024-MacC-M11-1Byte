//
//  ObjectiveView.swift
//  OneByte
//
//  Created by 트루디 on 10/17/24.
//

import SwiftUI

struct MandalartView: View {
    
    var body: some View {
        let createService = ClientCreateService()
        let viewModel = MadalArtCRUDTestViewModel(createService: createService)
        MandalArtCRUDTestView(viewModel: viewModel) // 뷰에 뷰모델 전달
    }
}
