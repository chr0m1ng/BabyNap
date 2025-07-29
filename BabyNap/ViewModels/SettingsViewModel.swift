//
//  SettingsViewModel.swift
//  BabyNap
//
//  Created by Gabriel Santos on 28/7/25.
//

import Foundation
import Combine

let DEFAULT_SLEEP_WINDOW_MINUTES = 90
let DEFAULT_NOTIFICATION_LEAD_MINUTES = 10

class SettingsViewModel: ObservableObject {
    @Published var babyName: String {
        didSet { UserDefaults.standard.set(babyName, forKey: "babyName") }
    }

    @Published var sleepWindowMinutes: Int {
        didSet { UserDefaults.standard.set(sleepWindowMinutes, forKey: "sleepWindowMinutes") }
    }

    @Published var notificationLeadMinutes: Int {
        didSet { UserDefaults.standard.set(notificationLeadMinutes, forKey: "notificationLeadMinutes") }
    }

    init() {
        self.babyName = UserDefaults.standard.string(forKey: "babyName") ?? ""
        self.sleepWindowMinutes = UserDefaults.standard.integer(forKey: "sleepWindowMinutes")
        self.notificationLeadMinutes = UserDefaults.standard.integer(forKey: "notificationLeadMinutes")
        if sleepWindowMinutes == 0 { sleepWindowMinutes = DEFAULT_SLEEP_WINDOW_MINUTES }
        if notificationLeadMinutes == 0 { notificationLeadMinutes = DEFAULT_NOTIFICATION_LEAD_MINUTES }
    }
}

