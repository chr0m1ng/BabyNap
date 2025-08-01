//
//  HomeViewModel.swift
//  BabyNap
//
//  Created by Gabriel Santos on 28/7/25.
//

import Foundation
import SwiftData
import SwiftUI


enum SleepWindowStatus {
   case none
   case warning
   case overdue
}

@MainActor
class HomeViewModel: ObservableObject {
    @Published var activeSession: ActionSession?
    @Published var showUndoBanner = false
    @AppStorage("sleepWindowMinutes") private var sleepWindowMinutes: Int = 90
    @AppStorage("notificationLeadMinutes") private var notificationLeadMinutes: Int = 15
    @AppStorage("babyName") private var babyName: String = ""
    
    private var previousSession: ActionSession?
    private var undoTimer: Timer?
    private var modelContext: ModelContext!
    
    var displayBabyName: String {
        babyName.isEmpty ? String(localized: "home.status.babyName.default") : babyName
    }

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
        ensureActiveSession()
    }

    func toggleSession() {
        undoTimer?.invalidate()

        // Save previous session
        let current = activeSession
        previousSession = current

        // End previous
        if let session = current {
            session.endedAt = Date()
        }

        // Insert new
        let newAction: Action = current?.action == .Nap ? .Wake : .Nap
        let session = ActionSession(startedAt: Date(), action: newAction)
        modelContext.insert(session)
        try? modelContext.save()
        activeSession = session
        
        // 🔔 Schedule sleep window notifications if it's a Wake session
        if newAction == .Wake {
            NotificationScheduler.shared.clearAllSleepWindowNotifications()

            let warningDate = Date().addingTimeInterval(Double((sleepWindowMinutes - notificationLeadMinutes) * 60))
            let overdueDate = Date().addingTimeInterval(Double(sleepWindowMinutes * 60))

            NotificationScheduler.shared.scheduleSleepWindowWarning(at: warningDate)
            NotificationScheduler.shared.scheduleSleepWindowOverdue(at: overdueDate)
        } else {
            NotificationScheduler.shared.clearAllSleepWindowNotifications()
        }

        // Show undo
        showUndoBanner = true
        undoTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [weak self] _ in
            Task { @MainActor in
                await self?.commitUndo()
            }
        }

    }
    
    func undoLastAction() {
        guard let previous = previousSession, let current = activeSession else { return }

        // Remove new session
        modelContext.delete(current)

        // Restore old
        previous.endedAt = nil
        activeSession = previous

        try? modelContext.save()

        showUndoBanner = false
        undoTimer?.invalidate()
        undoTimer = nil

        // 🔕 Cancel notifications (if user had just marked Wake)
        NotificationScheduler.shared.clearAllSleepWindowNotifications()
    }

    
    private func commitUndo() async {
        showUndoBanner = false
        previousSession = nil
        undoTimer?.invalidate()
        undoTimer = nil
    }
    
    func shouldShowSleepWindowWarning(at date: Date) -> Bool {
        guard let session = activeSession, session.action == .Wake else { return false }
        let elapsed = date.timeIntervalSince(session.startedAt)
        let threshold = Double((sleepWindowMinutes - notificationLeadMinutes) * 60)
        return elapsed >= threshold
    }
    
    func sleepWindowStatus(at date: Date) -> SleepWindowStatus {
        guard let session = activeSession, session.action == .Wake else { return .none }
        let elapsed = date.timeIntervalSince(session.startedAt)
        let warningThreshold = Double((sleepWindowMinutes - notificationLeadMinutes) * 60)
        let overdueThreshold = Double(sleepWindowMinutes * 60)

        if elapsed >= overdueThreshold {
            return .overdue
        } else if elapsed >= warningThreshold {
            return .warning
        } else {
            return .none
        }
    }
    
    func sleepWindowDeltaMinutes(at date: Date, status: SleepWindowStatus) -> Int? {
        guard let session = activeSession, session.action == .Wake else { return nil }
        let elapsed = date.timeIntervalSince(session.startedAt)
        let limit = Double(sleepWindowMinutes * 60)

        switch status {
        case .warning:
            return Int((limit - elapsed) / 60)
        case .overdue:
            return Int((elapsed - limit) / 60)
        default:
            return nil
        }
    }

    private func ensureActiveSession() {
        let descriptor = FetchDescriptor<ActionSession>(
            predicate: #Predicate { $0.endedAt == nil },
            sortBy: [SortDescriptor(\.startedAt, order: .reverse)]
        )

        if let existing = try? modelContext.fetch(descriptor).first {
            activeSession = existing
        } else {
            let session = ActionSession(startedAt: Date(), action: .Wake)
            modelContext.insert(session)
            try? modelContext.save()
            activeSession = session
        }
    }
}
