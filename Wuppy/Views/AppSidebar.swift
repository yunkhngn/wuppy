//
//  AppSidebar.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI

enum AppScreen: Hashable, Identifiable, CaseIterable {
    case dashboard
    case jobs
    case debts
    case transactions
    case goals
    case settings
    
    var id: Self { self }
    
    var title: LocalizedStringKey {
        switch self {
        case .dashboard: return "dashboard_title"
        case .jobs: return "jobs_title"
        case .debts: return "debts_title"
        case .transactions: return "transactions_title"
        case .goals: return "goals_title"
        case .settings: return "settings_title"
        }
    }
    
    var icon: String {
        switch self {
        case .dashboard: return "square.grid.2x2"
        case .jobs: return "briefcase"
        case .debts: return "banknote"
        case .transactions: return "list.bullet.rectangle"
        case .goals: return "target"
        case .settings: return "gear"
        }
    }
}

struct AppSidebar: View {
    @Binding var selection: AppScreen?
    
    var body: some View {
        List(selection: $selection) {
            ForEach(AppScreen.allCases) { screen in
                NavigationLink(value: screen) {
                    Label(screen.title, systemImage: screen.icon)
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("app_name")
    }
}
