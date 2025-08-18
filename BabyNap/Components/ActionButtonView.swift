//
//  ActionButtonView.swift
//  BabyNap
//
//  Created by Gabriel Santos on 18/8/25.
//

import SwiftUI

struct ActionButtonView: View {
    let isNapping: Bool
    let toggle: () -> Void

    var body: some View {
        Button(action: toggle) {
            Image(systemName: isNapping ? "sun.max.fill" : "moon.fill")
                .font(.system(size: 30))
                .padding()
                .frame(width: 120, height: 120)
                .background(isNapping ? Color.green : Color.blue)
                .foregroundColor(.white)
                .clipShape(Circle())
                .shadow(radius: 10)
        }
    }
}
