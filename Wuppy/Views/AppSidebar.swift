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
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 4) {
                    ForEach(AppScreen.allCases) { screen in
                        Button {
                            selection = screen
                        } label: {
                            HStack(spacing: 12) {
                                Image(systemName: screen.icon)
                                    .font(.system(size: 16, weight: .medium))
                                    .frame(width: 24)
                                
                                Text(screen.title)
                                    .font(.system(size: 14, weight: .medium))
                                
                                Spacer()
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 10)
                            .foregroundStyle(selection == screen ? AppColors.accent : AppColors.textSecondary)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(selection == screen ? AppColors.accent.opacity(0.15) : Color.clear)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selection == screen ? AppColors.accent.opacity(0.3) : Color.clear, lineWidth: 1)
                            )
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(12)
            }
        }
        .background(.ultraThinMaterial)
        .navigationTitle("app_name")
    }
}
