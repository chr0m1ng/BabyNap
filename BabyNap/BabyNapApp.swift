import SwiftUI
import SwiftData
import UserNotifications

@main
struct BabyNapApp: App {
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
