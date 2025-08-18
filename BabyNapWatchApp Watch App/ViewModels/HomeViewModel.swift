//
//  HomeViewModel.swift
//  BabyNap
//
//  Created by Gabriel Santos on 13/8/25.
//

import Foundation
import SwiftData
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var activeSession: ActionSession?
    @AppStorage("babyName") private var babyName: String = ""

    private var modelContext: ModelContext!
    
    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
        ensureActiveSession()
    }
    
    var displayBabyName: String {
        babyName.isEmpty ? String(localized: "home.status.babyName.default") : babyName
    }
    
    func sleepWindowStatus(at date: Date) -> SleepWindowStatus {
        return .none
    }

    func formatTimer(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: interval) ?? "--:--:--"
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

