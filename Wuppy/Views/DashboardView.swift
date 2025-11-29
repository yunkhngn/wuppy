//
//  DashboardView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI

import SwiftData
import Charts

struct DashboardView: View {
    @Query private var transactions: [Transaction]
    @Query private var debts: [Debt]
    @Query private var jobs: [Job]
    @Query private var goals: [Goal]
    
    var incomeByCurrency: [String: Double] {
        Dictionary(grouping: transactions.filter { $0.type == .income }, by: { $0.currency })
            .mapValues { $0.reduce(0) { $0 + $1.amount } }
    }
    
    var expensesByCurrency: [String: Double] {
        Dictionary(grouping: transactions.filter { $0.type == .expense }, by: { $0.currency })
            .mapValues { $0.reduce(0) { $0 + $1.amount } }
    }
    
    var debtIOweByCurrency: [String: Double] {
        Dictionary(grouping: debts.filter { $0.role == .iOwe }, by: { $0.currency })
            .mapValues { $0.reduce(0) { $0 + $1.remainingAmount } }
    }
    
    var debtOwedToMeByCurrency: [String: Double] {
        Dictionary(grouping: debts.filter { $0.role == .theyOweMe }, by: { $0.currency })
            .mapValues { $0.reduce(0) { $0 + $1.remainingAmount } }
    }
    
    var netResult: [String: Double] {
        let currencies = Set(incomeByCurrency.keys).union(expensesByCurrency.keys)
        return currencies.reduce(into: [:]) { dict, currency in
            let income = incomeByCurrency[currency] ?? 0
            let expense = expensesByCurrency[currency] ?? 0
            dict[currency] = income - expense
        }
    }
    
    var currentDateString: String {
        Date().formatted(.dateTime.weekday(.wide).day().month())
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text(currentDateString)
                            .font(.subheadline)
                            .foregroundStyle(AppColors.textSecondary)
                            .textCase(.uppercase)
                        
                        Text("dashboard_title")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColors.textPrimary)
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                // Summary Cards
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 220))], spacing: 20) {
                    MultiCurrencySummaryCard(title: "total_income", amounts: incomeByCurrency, color: AppColors.income, icon: "arrow.down.left")
                    MultiCurrencySummaryCard(title: "total_expenses", amounts: expensesByCurrency, color: AppColors.expense, icon: "arrow.up.right")
                    
                    MultiCurrencySummaryCard(title: "net_result", amounts: netResult, color: AppColors.accent, icon: "chart.bar.fill")
                }
                .padding(.horizontal)
                
                // Debts Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundStyle(AppColors.accent)
                        Text("debts_title")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(AppColors.textPrimary)
                    }
                    .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 220))], spacing: 20) {
                        MultiCurrencySummaryCard(title: "i_owe", amounts: debtIOweByCurrency, color: AppColors.expense, icon: "hand.thumbsdown.fill")
                        MultiCurrencySummaryCard(title: "they_owe_me", amounts: debtOwedToMeByCurrency, color: AppColors.income, icon: "hand.thumbsup.fill")
                    }
                    .padding(.horizontal)
                }
                
                // Goals Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "target")
                            .foregroundStyle(AppColors.accent)
                        Text("goals_title")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(AppColors.textPrimary)
                    }
                    .padding(.horizontal)
                    
                    if goals.isEmpty {
                        Text("no_goals")
                            .foregroundStyle(AppColors.textSecondary)
                            .padding(.horizontal)
                    } else {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(goals) { goal in
                                    GoalDashboardCard(goal: goal)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }

                // Charts Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "chart.xyaxis.line")
                            .foregroundStyle(AppColors.accent)
                        Text("analytics_title")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(AppColors.textPrimary)
                    }
                    .padding(.horizontal)
                    
                    if transactions.isEmpty {
                        HStack {
                            Spacer()
                            VStack(spacing: 12) {
                                Image(systemName: "chart.bar.xaxis")
                                    .font(.system(size: 40))
                                    .foregroundStyle(AppColors.textSecondary.opacity(0.5))
                                Text("no_analytics_data")
                                    .font(.subheadline)
                                    .foregroundStyle(AppColors.textSecondary)
                            }
                            .padding(.vertical, 40)
                            Spacer()
                        }
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                        .padding(.horizontal)
                    } else {
                        AnalyticsChartsView()
                            .padding()
                            .wuppyCardStyle()
                            .padding(.horizontal)
                    }
                }
                
                Spacer()
            }
            .padding(.vertical)
        }

    }
}

struct MultiCurrencySummaryCard: View {
    let title: LocalizedStringKey
    let amounts: [String: Double]
    let color: Color
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.1))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(color)
                }
                
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(AppColors.textSecondary)
                
                if amounts.isEmpty {
                    Text(0, format: .currency(code: "VND"))
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .foregroundStyle(AppColors.textPrimary)
                } else {
                    ForEach(amounts.sorted(by: { $0.key < $1.key }), id: \.key) { currency, amount in
                        Text(amount, format: .currency(code: currency))
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundStyle(AppColors.textPrimary)
                    }
                }
            }
        }
        .padding(16)
        .wuppyCardStyle()
    }
}

struct GoalDashboardCard: View {
    let goal: Goal
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(goal.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .foregroundStyle(AppColors.textPrimary)
                Spacer()
                Text(goal.progress, format: .percent.precision(.fractionLength(0)))
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(AppColors.background)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(AppColors.accent)
                    .clipShape(Capsule())
            }
            
            ProgressView(value: goal.currentAmount, total: goal.targetAmount)
                .tint(AppColors.accent)
            
            HStack {
                Text(goal.currentAmount, format: .currency(code: goal.currency))
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(AppColors.textSecondary)
                Spacer()
                Text(goal.targetAmount, format: .currency(code: goal.currency))
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(AppColors.textSecondary)
            }
        }
        .padding(16)
        .frame(width: 250)
        .wuppyCardStyle()
    }
}
