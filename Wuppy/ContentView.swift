//
//  ContentView.swift
//  Wuppy
//
//  Created by Khoa Nguyễn on 29/11/2025.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selection: AppScreen? = .dashboard
    
    var body: some View {
        NavigationSplitView {
            AppSidebar(selection: $selection)
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
            case .none:
                Text("Select an item")
            }
        }
        }
    }

#Preview {
    ContentView()
}
