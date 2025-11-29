//
//  ContentView.swift
//  Wuppy
//
//  Created by Khoa Nguyễn on 29/11/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selection: AppScreen = .dashboard
    
    var body: some View {
        NavigationSplitView {
            AppSidebar(selection: Binding(
                get: { selection },
                set: { if let value = $0 { selection = value } }
            ))
        } detail: {
            switch selection {
            case .dashboard:
                DashboardView()
            case .jobs:
                JobsView()
            case .debts:
                DebtsView()
            case .transactions:
                TransactionsView()
            case .goals:
                GoalsView()
            case .settings:
                NavigationStack {
                    SettingsView()
                }
            }
        }
        .background(AppColors.background)
        .preferredColorScheme(.dark) // Force dark mode
    }
}

#Preview {
    ContentView()
}
