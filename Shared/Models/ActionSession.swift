//
//  ActionSession.swift
//  BabyNap
//
//  Created by Gabriel Santos on 28/7/25.
//

import Foundation
import SwiftData

enum Action: String, Codable {
    case Nap
    case Wake
}

@Model
class ActionSession {
    var startedAt: Date = Date.now
    var endedAt: Date?
    var action: Action = Action.Nap
    
    init(startedAt: Date, endedAt: Date? = nil, action: Action) {
        self.startedAt = startedAt
        self.endedAt = endedAt
        self.action = action
    }
}
