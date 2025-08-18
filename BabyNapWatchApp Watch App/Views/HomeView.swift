//
//  HomeView.swift
//  BabyNap Watch
//
//  Created by Gabriel Santos on 28/7/25.
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var viewModel = HomeViewModel()
    @State private var isConfigured = false

    var body: some View {
        VStack {
            TimelineView(.periodic(from: .now, by: 1)) { context in
                let now = context.date
                let status = viewModel.sleepWindowStatus(at: now)
                let elapsedTime = viewModel.activeSession.map {
                    now.timeIntervalSince($0.startedAt)
                } ?? 0
                VStack {
                    ZStack(alignment: .bottom) {
                        Text(viewModel.activeSession?.action == .Nap ? "🌙" : "☀️")
                            .font(.system(size: 80))
                            .opacity(0.12)
                            .blur(radius: 1)
                            .alignmentGuide(.firstTextBaseline) { d in d[.bottom] }

                        Text(viewModel.activeSession?.action == .Nap
                             ? "home.baby.status.napping \(viewModel.displayBabyName)"
                             : "home.baby.status.awake \(viewModel.displayBabyName)")
                            .font(.title2)
                            .bold()
                    }
                    Text(viewModel.formatTimer(elapsedTime))
                        .font(.system(size: 25, weight: .bold, design: .monospaced))
                        .monospacedDigit()
                        .id(Int(elapsedTime))
                        .contentTransition(.numericText())
                }
            }
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
