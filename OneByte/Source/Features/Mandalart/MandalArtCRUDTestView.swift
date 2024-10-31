//
//  MandalArtCRUDTestView.swift
//  OneByte
//
//  Created by 트루디 on 10/30/24.
//

import SwiftUI

struct MandalArtCRUDTestView: View {
    @StateObject var viewModel: MadalArtCRUDTestViewModel
    @State private var goalTitle: String = ""
    
    init(viewModel: MadalArtCRUDTestViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
//
//    init(viewModel: MadalArtCRUDTestViewModel = MandalArtCRUDTestView(createService: ClientCreateService)) {
//        self.viewModel = viewModel
//    }
    var body: some View {
        VStack {
                    TextField("Enter Main Goal Title", text: $goalTitle)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("Create Main Goal") {
                        let newGoal = viewModel.createMainGoal(title: goalTitle)
                        print("Created Main Goal: \(newGoal.title)")
                        print(newGoal.id)
                        print(newGoal.isAchieved)
                        print(newGoal.subGoals)
                        goalTitle = ""  // Reset the input field
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)

                    List(viewModel.mainGoals, id: \.id) { goal in
                        Text(goal.title)
                    }
                }
                .padding()
    }
}
