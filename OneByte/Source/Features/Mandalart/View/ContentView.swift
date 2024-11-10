//
//  ContentView.swift
//  OneByte
//
//  Created by 트루디 on 11/7/24.
//

//import SwiftUI
//import SwiftData
//
//struct ContentView: View {
//    
//    @AppStorage("isFirstOnboarding") var isFirstOnboarding: Bool = true // App Onboarding
//    @State var isPresented = false
//    
//    @Environment(\.modelContext) private var modelContext  // SwiftData 컨텍스트
//    
//    private let viewModel = CUTestViewModel(createService: ClientCreateService(), updateService: ClientUpdateService(mainGoals: [], subGoals: [], detailGoals: []))
//    var body: some View {
//        NavigationStack{
//            VStack {
//                NavigationLink(destination: MandalartView(), label: {
//                    Text("가보깅")
//                })
//                Button("생성하기") {
//                    viewModel.createGoals(modelContext: modelContext)
//                }
//            }
//        }
//    }
//}
