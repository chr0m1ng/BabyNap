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

    var body: some View {
        NavigationStack {
            TimelineView(.periodic(from: .now, by: 1)) { context in
                let now = context.date
                let status = viewModel.sleepWindowStatus(at: now)
                let elapsedTime = viewModel.activeSession.map { now.timeIntervalSince($0.startedAt) } ?? 0

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

                    Text(viewModel.formatTimer(elapsedTime))
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .monospacedDigit()
                        .id(Int(elapsedTime))
                        .contentTransition(.numericText())

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
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gear")
                    }
                }
            }
            .navigationDestination(isPresented: $showingSettings) {
                SettingsView()
            }
            .navigationTitle(Text("home.navigation.title"))
        }
        .onAppear {
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
