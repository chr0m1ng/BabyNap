//
//  UndoBannerView.swift
//  BabyNap
//
//  Created by Gabriel Santos on 18/8/25.
//

import SwiftUI

struct UndoBannerView: View {
    let showing: Bool
    @Binding var progress: CGFloat
    let undoAction: () -> Void

    var body: some View {
        Group {
            if showing {
                VStack(spacing: 4) {
                    HStack(spacing: 12) {
                        Image(systemName: "arrow.uturn.backward.circle.fill")
                            .foregroundColor(.blue)
                        Text("home.undo.bar.title")
                            .font(.subheadline)
                        Spacer()
                        Button("home.undo.bar.action") {
                            undoAction()
                        }
                        .font(.subheadline.bold())
                        .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                    .padding(.top, 12)

                    GeometryReader { geo in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(Color.blue)
                            .frame(width: geo.size.width * progress, height: 4)
                            .animation(.easeInOut(duration: 3), value: progress)
                    }
                    .frame(height: 4)
                    .padding(.horizontal)
                    .padding(.bottom, 12)
                }
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding(.horizontal)
                .transition(.asymmetric(
                    insertion: .move(edge: .leading).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                .onAppear {
                    progress = 1.0
                    withAnimation(.easeInOut(duration: 3)) {
                        progress = 0.0
                    }
                }
                .onDisappear {
                    progress = 1.0
                }
            } else {
                Color.clear
            }
        }
        // Fixed height to prevent layout shifts whether visible or hidden
        .frame(height: 72)
    }
}
