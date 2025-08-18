//
//  BabyNapWatchApp.swift
//  BabyNap Watch
//
//  Created by Gabriel Santos on 1/8/25.
//

import SwiftUI
import SwiftData

@main
struct BabyNapWatchApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ActionSession.self,
        ])
        let configuration = ModelConfiguration(
            schema: schema, isStoredInMemoryOnly: false, allowsSave: true, groupContainer: .automatic, cloudKitDatabase: .automatic
        )
        let container = try! ModelContainer(for: schema, configurations: [configuration])
        return container
    }()
    
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }.modelContainer(sharedModelContainer)
    }
}
