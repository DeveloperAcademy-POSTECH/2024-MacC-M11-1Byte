//
//  RoutinePopUpView.swift
//  OneByte
//
//  Created by 이상도 on 12/21/24.
//

import SwiftUI

// 루틴뷰에서 QuestionMark 통한 PopUp MessageView
struct RoutinePopUpView: View {
    
    @Binding var isInfoVisible: Bool
    
    var body: some View {
        VStack(spacing: -5) {
            HStack {
                Spacer()
                Image("Stat_Polygon")
                    .padding(.trailing, 22)
            }
            HStack {
                Spacer()
                Rectangle()
                    .frame(width: 162, height: 190)
                    .foregroundStyle(.my897C6E)
                    .cornerRadius(8)
                    .overlay {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("진행도 상태 표시")
                                    .font(.setPretendard(weight: .bold, size: 13))
                                    .foregroundStyle(.white)
                                Spacer()
                                Button {
                                    isInfoVisible = false
                                } label: {
                                    Image(systemName: "xmark")
                                        .resizable()
                                        .bold()
                                        .frame(width: 10, height: 10)
                                        .foregroundStyle(.white)
                                }
                            }
                            
                            HStack(spacing: 8) {
                                Image("RoutinePopup1")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                Text("루틴을 완료했어요")
                                    .font(.setPretendard(weight: .semiBold, size: 13))
                                    .foregroundStyle(.white)
                            }
                            .padding(.top, 4)
                            
                            HStack(spacing: 8) {
                                Image("RoutinePopup2")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                Text("루틴을 못했어요")
                                    .font(.setPretendard(weight: .semiBold, size: 13))
                                    .foregroundStyle(.white)
                            }
                            HStack(spacing: 8) {
                                Image("RoutinePopup3")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                Text("루틴을 해야해요")
                                    .font(.setPretendard(weight: .semiBold, size: 13))
                                    .foregroundStyle(.white)
                            }
                            HStack(spacing: 8) {
                                Image("RoutinePopup4")
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                Text("루틴이 없어요")
                                    .font(.setPretendard(weight: .semiBold, size: 13))
                                    .foregroundStyle(.white)
                            }
                        }
                        .padding(12)
                    }
            }
            .padding(.trailing, 16)
        }
    }
}
