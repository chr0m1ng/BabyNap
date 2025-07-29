//
//  SettingsView.swift
//  BabyNap
//
//  Created by Gabriel Santos on 28/7/25.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()

    var body: some View {
        Form {
            Section("settings.baby.section") {
                TextField("settings.baby.name", text: $viewModel.babyName)
                    .autocapitalization(.words)
            }

            Section("settings.sleep.section") {
                Stepper(value: $viewModel.sleepWindowMinutes, in: 30...240, step: 5) {
                    Text(String.localizedStringWithFormat(
                        String(localized: "settings.sleep.details"),
                        viewModel.sleepWindowMinutes))
                }
            }

            Section("settings.notifications.section") {
                Stepper(value: $viewModel.notificationLeadMinutes, in: 1...60, step: 1) {
                    Text("settings.notifications.details \(viewModel.notificationLeadMinutes)")
                }
            }
        }
        .navigationTitle("menu.settings")
    }
}


#Preview {
    SettingsView()
}
