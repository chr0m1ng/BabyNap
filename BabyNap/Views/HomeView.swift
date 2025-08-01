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
    
    @State private var undoProgress: CGFloat = 1.0

    var body: some View {
        NavigationStack {
            TimelineView(.periodic(from: .now, by: 1)) { context in
                let now = context.date
                let status = viewModel.sleepWindowStatus(at: now)
                let elapsedTime = viewModel.activeSession.map { now.timeIntervalSince($0.startedAt) } ?? 0

                VStack(spacing: 30) {
                    if viewModel.showUndoBanner {
                        VStack(spacing: 4) {
                            HStack(spacing: 12) {
                                Image(systemName: "arrow.uturn.backward.circle.fill")
                                    .foregroundColor(.blue)
                                Text("home.undo.bar.title")
                                    .font(.subheadline)
                                Spacer()
                                Button("home.undo.bar.action") {
                                    viewModel.undoLastAction()
                                }
                                .font(.subheadline.bold())
                                .foregroundColor(.blue)
                            }
                            .padding(.horizontal)
                            .padding(.top, 12)

                            GeometryReader { geo in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.blue)
                                    .frame(width: geo.size.width * undoProgress, height: 4)
                                    .animation(.easeInOut(duration: 3), value: undoProgress)
                            }
                            .frame(height: 4)
                            .padding(.horizontal)
                            .padding(.bottom, 12)
                        }
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                        .shadow(radius: 4)
                        .padding(.horizontal)
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity))
                        )
                        .onAppear {
                            undoProgress = 1.0
                            withAnimation(.easeInOut(duration: 3)) {
                                undoProgress = 0.0
                            }
                        }
                        .onDisappear {
                            undoProgress = 1.0
                        }
                    } else {
                        Color.clear.frame(height: 60)
                    }

                    ZStack(alignment: .bottom) {
                        Text(viewModel.activeSession?.action == .Nap ? "🌙" : "☀️")
                            .font(.system(size: 80))
                            .opacity(0.12)
                            .blur(radius: 1)
                            .alignmentGuide(.firstTextBaseline) { d in d[.bottom] }

                        Text(viewModel.activeSession?.action == .Nap
                             ? "home.baby.status.napping \(babyName)"
                             : "home.baby.status.wake \(babyName)")
                            .font(.title2)
                            .bold()
                    }


                    Text(format(elapsedTime))
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .monospacedDigit()
                        .transition(.opacity)
                        .id(Int(elapsedTime))
                        .animation(.easeInOut(duration: 0.25), value: elapsedTime)

                    Group {
                        if status != .none,
                           let minutes = viewModel.sleepWindowDeltaMinutes(at: now, status: status) {
                            Text(status == .overdue
                                 ? "home.status.subtext.overdue \(minutes)"
                                 : "home.status.subtext.warning \(minutes)")
                                .font(.subheadline)
                                .foregroundColor(status == .overdue ? .red : .blue)
                                .frame(maxWidth: .infinity, alignment: .center)
                        } else {
                            Text("").font(.subheadline).hidden()
                        }
                    }
                    .frame(height: 20)

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

                    Group {
                        if status != .none {
                            HStack(spacing: 8) {
                                Image(systemName: status == .overdue ? "xmark.octagon.fill" : "exclamationmark.triangle.fill")
                                    .foregroundColor(status == .overdue ? .red : .yellow)
                                Text(status == .overdue
                                     ? "home.baby.warning.sleepwindow.overdue"
                                     : "home.baby.warning.sleepwindow")
                                    .font(.subheadline)
                                    .foregroundColor(status == .overdue ? .red : .black)
                            }
                            .padding(.vertical, 10)
                            .padding(.horizontal, 20)
                            .background(status == .overdue ? Color(red: 1, green: 0.9, blue: 0.9)
                                                            : Color(red: 1.0, green: 0.95, blue: 0.7))
                            .clipShape(Capsule())
                            .shadow(radius: 3)
                            .multilineTextAlignment(.center)
                            .padding(.top, 10)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.3), value: status)
                        } else {
                            Spacer().frame(height: 52)
                        }
                    }

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
