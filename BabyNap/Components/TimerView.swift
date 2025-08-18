//
//  TimerView.swift
//  BabyNap
//
//  Created by Gabriel Santos on 18/8/25.
//

import SwiftUI

struct TimerView: View {
    let timeText: String
    let elapsed: TimeInterval

    var body: some View {
        Text(timeText)
            .font(.system(size: 48, weight: .bold, design: .monospaced))
            .monospacedDigit()
            .id(Int(elapsed))
            .contentTransition(.numericText())
    }
}
