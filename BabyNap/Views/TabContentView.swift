//
//  TabContentView.swift
//  BabyNap
//
//  Created by Gabriel Santos on 28/7/25.
//

import SwiftUI

struct TabContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("tab.home", systemImage: "house")
                }
            ReportsView()
                .tabItem {
                    Label("tab.reports", systemImage: "chart.bar")
                }
        }
    }
}

#Preview {
    TabContentView()
}
