//
//  HomeViewModel.swift
//  BabyNap
//
//  Created by Gabriel Santos on 28/7/25.
//

import Foundation
import SwiftData

class HomeViewModel: ObservableObject {
    @Published var activeSession: ActionSession?

    private var modelContext: ModelContext!

    func configure(modelContext: ModelContext) {
        self.modelContext = modelContext
        ensureActiveSession()
    }

    func toggleSession() {
        if let session = activeSession {
            session.endedAt = Date()
        }
        let newAction: Action = activeSession?.action == .Nap ? .Wake : .Nap
        let session = ActionSession(startedAt: Date(), action: newAction)
        modelContext.insert(session)
        try? modelContext.save()
        activeSession = session
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
