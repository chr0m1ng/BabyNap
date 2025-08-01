//
//  NotificationScheduler.swift
//  BabyNap
//
//  Created by Gabriel Santos on 1/8/25.
//

import Foundation
import UserNotifications

class NotificationScheduler {
    static let shared = NotificationScheduler()
    private init() {}

    private var babyName: String {
        UserDefaults.standard.string(forKey: "babyName") ?? NSLocalizedString("notification.babyName.default", comment: "")
    }

    func scheduleSleepWindowWarning(at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("notification.sleepWindowWarning.title", comment: "")
        content.body = String(format: NSLocalizedString("notification.sleepWindowWarning.body", comment: ""), babyName)
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(date.timeIntervalSinceNow, 1), repeats: false)
        let request = UNNotificationRequest(identifier: "sleepWindowWarning", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func scheduleSleepWindowOverdue(at date: Date) {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString("notification.sleepWindowOverdue.title", comment: "")
        content.body = String(format: NSLocalizedString("notification.sleepWindowOverdue.body", comment: ""), babyName)
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: max(date.timeIntervalSinceNow, 1), repeats: false)
        let request = UNNotificationRequest(identifier: "sleepWindowOverdue", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    func clearAllSleepWindowNotifications() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [
            "sleepWindowWarning",
            "sleepWindowOverdue"
        ])
    }
}
