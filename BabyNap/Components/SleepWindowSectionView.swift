//
//  SleepWindowSectionView.swift
//  BabyNap
//
//  Created by Gabriel Santos on 18/8/25.
//

import SwiftUI

struct SleepWindowSectionView: View {
    let status: SleepWindowStatus
    let minutes: Int?

    var body: some View {
        VStack(spacing: 10) {
            if let minutes {
                Text(status == .overdue
                     ? "home.status.subtext.overdue \(minutes)"
                     : "home.status.subtext.warning \(minutes)")
                    .font(.subheadline)
                    .foregroundColor(status == .overdue ? .red : .blue)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .frame(height: 20)

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
            } else {
                Color.clear.frame(height: 82)
            }
        }
    }
}
