//
//  OneByteApp.swift
//  OneByte
//
//  Created by 이상도 on 10/17/24.
//

import SwiftUI
import SwiftData

@main
struct OneByteApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            MainGoal.self,
            SubGoal.self,
            DetailGoal.self,
            Profile.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error.localizedDescription)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            TabBarManager()
                .modelContainer(sharedModelContainer)
        }
    }
}
