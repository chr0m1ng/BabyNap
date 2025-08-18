//
//  HomeView.swift
//  BabyNap
//
//  Created by Gabriel Santos on 28/7/25.
//

import SwiftUI
import TipKit

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = HomeViewModel()
    @State private var isConfigured = false
    @State private var showingSettings = false

    @State private var undoProgress: CGFloat = 1.0
    
    let settingsTip = SettingsTip()

    var body: some View {
        NavigationStack {
            TimelineView(.periodic(from: .now, by: 1)) { context in
                let now = context.date
                let status = viewModel.sleepWindowStatus(at: now)

                VStack(spacing: 30) {
                    UndoBannerView(
                        showing: viewModel.showUndoBanner,
                        progress: $undoProgress,
                        undoAction: viewModel.undoLastAction
                    )

                    StatusView(
                        isNapping: viewModel.activeSession?.action == .Nap,
                        babyName: viewModel.displayBabyName
                    )

                    TimerView(timeText: viewModel.formattedElapsedTime, elapsed: viewModel.elapsedTime)

                    SleepWindowSectionView(
                        status: status,
                        minutes: viewModel.sleepWindowDeltaMinutes(at: now, status: status)
                    )

                    ActionButtonView(
                        isNapping: viewModel.activeSession?.action == .Nap,
                        toggle: viewModel.toggleSession
                    )

                    Spacer(minLength: 0)
                }
                .padding()
                .onChange(of: context.date, initial: false) { _, newDate in
                    viewModel.updateElapsedTime(now: newDate)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSettings = true
                        settingsTip.invalidate(reason: .actionPerformed)
                    } label: {
                        Image(systemName: "gear")
                            .popoverTip(settingsTip, arrowEdge: .bottom)
                    }
                }
            }
            .navigationDestination(isPresented: $showingSettings) {
                SettingsView()
            }
            .navigationTitle(Text("home.navigation.title"))
        }
        .onAppear {
            try! Tips.configure()
            viewModel.updateElapsedTime(now: Date())
            if !isConfigured {
                viewModel.configure(modelContext: modelContext)
                isConfigured = true
            }
        }
    }
}


#Preview {
    HomeView()
}
