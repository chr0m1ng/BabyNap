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
    @State private var showingSettings = false

    var body: some View {
        NavigationStack {
            TimelineView(.periodic(from: .now, by: 1)) { context in
                let now = context.date
                let status = viewModel.sleepWindowStatus(at: now)
                let elapsedTime = viewModel.activeSession.map { now.timeIntervalSince($0.startedAt) } ?? 0

                VStack(spacing: 16) {
                    ZStack(alignment: .bottom) {
                        Text(viewModel.activeSession?.action == .Nap ? "🌙" : "☀️")
                            .font(.system(size: 50))
                            .opacity(0.1)
                            .blur(radius: 1)

                        Text(viewModel.activeSession?.action == .Nap
                             ? "home.baby.status.napping \(viewModel.displayBabyName)"
                             : "home.baby.status.awake \(viewModel.displayBabyName)")
                            .font(.headline)
                            .bold()
                            .multilineTextAlignment(.center)
                    }

                    Text(format(elapsedTime))
                        .font(.system(size: 30, weight: .bold, design: .monospaced))
                        .monospacedDigit()
                        .id(Int(elapsedTime))

                    if status != .none {
                        HStack(spacing: 4) {
                            Image(systemName: status == .overdue ? "xmark.octagon.fill" : "exclamationmark.triangle.fill")
                                .foregroundColor(status == .overdue ? .red : .yellow)
                                .font(.footnote)

                            Text(status == .overdue
                                 ? "home.status.subtext.overdue.minimal"
                                 : "home.status.subtext.warning.minimal")
                                .font(.footnote)
                                .foregroundColor(status == .overdue ? .red : .yellow)
                                .lineLimit(1)
                        }
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(status == .overdue
                                    ? Color(red: 1, green: 0.9, blue: 0.9)
                                    : Color(red: 1.0, green: 0.95, blue: 0.7))
                        .clipShape(Capsule())
                        .shadow(radius: 2)
                    }

                    Button(action: viewModel.toggleSession) {
                        Image(systemName: viewModel.activeSession?.action == .Nap ? "sun.max.fill" : "moon.fill")
                            .font(.system(size: 24))
                            .frame(width: 50, height: 50)
                            .padding()
                            .background(viewModel.activeSession?.action == .Nap ? Color.green : Color.blue)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .buttonStyle(.plain)

                    Spacer(minLength: 0)
                }
                .padding()
            }
        }
        .onAppear {
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
