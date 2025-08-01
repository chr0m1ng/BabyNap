import SwiftUI
import SwiftData
import UserNotifications

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
                .onAppear {
                    requestNotificationPermission()
                }
        }
        .modelContainer(sharedModelContainer)
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("⚠️ Notification permission error: \(error)")
            } else {
                print(granted ? "✅ Notification permission granted" : "❌ Notification permission denied")
            }
        }
    }
}
