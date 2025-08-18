//
//  StatusView.swift
//  BabyNap
//
//  Created by Gabriel Santos on 18/8/25.
//

import SwiftUI

struct StatusView: View {
    let isNapping: Bool
    let babyName: String

    var body: some View {
        ZStack(alignment: .bottom) {
            Text(isNapping ? "🌙" : "☀️")
                .font(.system(size: 80))
                .opacity(0.12)
                .blur(radius: 1)
                .alignmentGuide(.firstTextBaseline) { d in d[.bottom] }

            Text(isNapping
                 ? "home.baby.status.napping \(babyName)"
                 : "home.baby.status.awake \(babyName)")
            .font(.title2)
            .bold()
        }
    }
}
