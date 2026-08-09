//
//  WeekAchieveCell.swift
//  OneByte
//
//  Created by 이상도 on 11/28/24.
//

import SwiftUI
import SwiftData

struct WeekAchieveCell: View {
    
    @State var viewModel = AllRoutineViewModel()
    let detailGoal: DetailGoal
    
    var body: some View {
        VStack(spacing: 12) {
            VStack(spacing: 4) {
                HStack {
                    Text(detailGoal.title)
                        .font(.setPretendard(weight: .bold, size: 16))
                        .foregroundStyle(.my2B2B2B)
                    
                    Spacer()
                    
                    Text("달성한 횟수 \(viewModel.achievedCount(for: detailGoal))/\(detailGoal.achieveGoal)개")
                        .font(.setPretendard(weight: .medium, size: 12))
                        .foregroundStyle(.my727272)
                }
                HStack {
                    Text(detailGoal.remindTime?.alertTimeString ?? "")
                        .font(.setPretendard(weight: .medium, size: 12))
                        .foregroundStyle(.my727272)
                    
                    Spacer()
                }
            }
            .padding(.top)
            
            HStack {
                ForEach(0..<viewModel.days.count, id: \.self) { index in
                    VStack(spacing: 4) {
                        Text(viewModel.days[index])
                            .font(.setPretendard(weight: .medium, size: 11))
                            .foregroundStyle(.my7D7D7D)
                            .frame(width: 18, height: 18)
                            .clipShape(Circle())
                        
                        ZStack {
                            switch viewModel.weekSlotState(for: detailGoal, at: index) {
                            case .achieved(let count):
                                viewModel.setGradationClover(for: detailGoal.achieveGoal, achieveCount: count)
                                    .resizable()
                                    .scaledToFit()
                            case .todayPending:
                                Image("RoutineDay")
                                    .resizable()
                                    .scaledToFit()
                            case .futurePending:
                                Image("RoutineNotYet")
                                    .resizable()
                                    .scaledToFit()
                            case .missed:
                                Image("NoAchieve")
                                    .resizable()
                                    .scaledToFit()
                            case .idle:
                                Image("NoRoutineDay")
                                    .resizable()
                                    .scaledToFit()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 18)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, 18.5)
        .background(.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(.myF0E8DF, lineWidth: 1)
        )
    }
}
