//
//  TaskView.swift
//  OneByte
//
//  Created by 트루디 on 10/17/24.
//

import SwiftUI

struct RetrospectMainView: View {
    
    @State private var navigationManager = NavigationManager()
    
    var body: some View {
        NavigationStack(path: $navigationManager.path) {
            VStack {
                HStack {
                    Text("베로님은\n총 5개의 꽃을 피웠어요") // 나중에 데이터 값으로 수정
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                .padding()
                
                Image(systemName: "camera.macro.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .frame(height: 280)
                
                Text("다음 회고까지 D-13") // 나중에 날짜 데이터 값으로 수정
                    .bold()
                
                Button {
                    navigationManager.push(to: .select)
                } label: {
                    Text("회고 하기")
                        .font(.system(size: 16))
                        .frame(width: 225, height: 38)
                }
                .background(.blue)
                .foregroundStyle(.white)
                .cornerRadius(8)
                
                HStack {
                    Button {
                        navigationManager.push(to: .total)
                    } label: {
                        Text("회고 모아보기")
                            .foregroundStyle(.black)
                            .bold()
                    }
                    Image(systemName: "chevron.right")
                        .bold()
                    
                    Spacer()
                }
                .padding()
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(0..<11) {_ in
                            VStack {
                                // 나중에 실제 회고 완료 데이터 값으로 수정
                                Image(systemName: "camera.macro.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                Text("월")
                                    .foregroundStyle(.black)
                            }
                        }
                    }
                    .frame(maxHeight: .infinity)
                    .padding()
                }
            }
            .navigationTitle("\(Date().YearString) 회고")
            .navigationDestination(for: PathType.self) { pathType in
                pathType.NavigatingView()
            }
        }
        .environment(navigationManager)
    }
}

#Preview {
    RetrospectMainView()
        .environment(NavigationManager())
}
