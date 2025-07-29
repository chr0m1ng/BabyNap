//
//  BabyNapApp.swift
//  BabyNap
//
//  Created by Gabriel Santos on 27/7/25.
//

import SwiftUI
import SwiftData

@main
struct BabyNapApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            ActionSession.self,
        ])
        let appGroupIdentifier = "group.com.chr0m1ngdev.babynap"
        do {
            let sharedURL = FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: appGroupIdentifier
            )!.appendingPathComponent("BabyNap.sqlite")
            let modelConfiguration = ModelConfiguration(schema: schema, url: sharedURL, allowsSave: true)
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            TabContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
