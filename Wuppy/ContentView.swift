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
        }
        .id(selection) // Force rebuild when selection changes
        .background(
            ZStack {
                AppColors.background
                
                // Subtle ambient gradients
                GeometryReader { proxy in
                    Circle()
                        .fill(AppColors.accent.opacity(0.1))
                        .blur(radius: 80)
                        .offset(x: -100, y: -100)
                    
                    Circle()
                        .fill(Color.purple.opacity(0.1))
                        .blur(radius: 80)
                        .offset(x: proxy.size.width * 0.8, y: proxy.size.height * 0.5)
                }
            }
            .ignoresSafeArea()
        )
        .preferredColorScheme(.dark) // Force dark mode
    }
}

#Preview {
    ContentView()
}
