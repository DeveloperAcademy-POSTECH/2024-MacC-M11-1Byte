//
//  OneByteApp.swift
//  OneByte
//
//  Created by 이상도 on 10/17/24.
//

import SwiftUI
import SwiftData
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    UserDefaults.saveDeviceUUID()
    return true
  }
}

@main
struct OneByteApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            MainGoal.self,
            SubGoal.self,
            DetailGoal.self,
            Clover.self,
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
            MainTabView()
                .modelContainer(sharedModelContainer)
        }
    }
}
