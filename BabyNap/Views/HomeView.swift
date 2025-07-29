//
//  HomeView.swift
//  BabyNap
//
//  Created by Gabriel Santos on 28/7/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = HomeViewModel()
    @State private var isConfigured = false
    @State private var showingSettings = false

    @AppStorage("babyName") private var babyName: String = "Baby"

    var body: some View {
        NavigationStack {
            TimelineView(.periodic(from: .now, by: 1)) { context in
                let now = context.date
                let elapsedTime = viewModel.activeSession.map { now.timeIntervalSince($0.startedAt) } ?? 0

                VStack(spacing: 30) {
                    Text(viewModel.activeSession?.action == .Nap
                         ? "home.baby.status.napping \(babyName)"
                         : "home.baby.status.wake \(babyName)")
                        .font(.title2)

                    Text(format(elapsedTime))
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .monospacedDigit()
                        .transition(.scale.combined(with: .opacity))
                        .id(Int(elapsedTime))
                        .animation(.easeInOut(duration: 0.25), value: elapsedTime)

                    Button(action: viewModel.toggleSession) {
                        Image(systemName: viewModel.activeSession?.action == .Nap ? "sun.max.fill" : "moon.fill")
                            .font(.system(size: 30))
                            .padding()
                            .frame(width: 120, height: 120)
                            .background(viewModel.activeSession?.action == .Nap ? Color.green : Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
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
            .navigationTitle(Text("tab.home"))
        }
        .onAppear {
            if babyName.isEmpty { babyName = "default.baby.name" }
            if !isConfigured {
                viewModel.configure(modelContext: modelContext)
                isConfigured = true
            }
        }
    }

    func format(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: interval) ?? "--:--:--"
    }
}

#Preview {
    HomeView()
}
