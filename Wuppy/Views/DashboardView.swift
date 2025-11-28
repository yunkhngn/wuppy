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
                            .foregroundStyle(.secondary)
                            .textCase(.uppercase)
                        
                        Text("dashboard_title")
                            .font(.system(size: 32, weight: .bold, design: .rounded))
                    }
                    Spacer()
                }
                .padding(.horizontal)
                
                // Summary Cards
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 220))], spacing: 20) {
                    MultiCurrencySummaryCard(title: "total_income", amounts: incomeByCurrency, gradient: WuppyColor.incomeGradient, icon: "arrow.down.left")
                    MultiCurrencySummaryCard(title: "total_expenses", amounts: expensesByCurrency, gradient: WuppyColor.expenseGradient, icon: "arrow.up.right")
                    
                    MultiCurrencySummaryCard(title: "net_result", amounts: netResult, gradient: WuppyColor.netResultGradient, icon: "chart.bar.fill")
                }
                .padding(.horizontal)
                
                // Debts Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "person.2.fill")
                            .foregroundStyle(.blue)
                        Text("debts_title")
                            .font(.title2)
                            .bold()
                    }
                    .padding(.horizontal)
                    
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 220))], spacing: 20) {
                        MultiCurrencySummaryCard(title: "i_owe", amounts: debtIOweByCurrency, gradient: WuppyColor.expenseGradient, icon: "hand.thumbsdown.fill")
                        MultiCurrencySummaryCard(title: "they_owe_me", amounts: debtOwedToMeByCurrency, gradient: WuppyColor.incomeGradient, icon: "hand.thumbsup.fill")
                    }
                    .padding(.horizontal)
                }
                
                // Goals Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "target")
                            .foregroundStyle(.orange)
                        Text("goals_title")
                            .font(.title2)
                            .bold()
                    }
                    .padding(.horizontal)
                    
                    if goals.isEmpty {
                        Text("no_goals")
                            .foregroundStyle(.secondary)
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
                            .foregroundStyle(.purple)
                        Text("Analytics")
                            .font(.title2)
                            .bold()
                    }
                    .padding(.horizontal)
                    
                    WuppyCard {
                        AnalyticsChartsView()
                            .padding()
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding(.vertical)
        }
        .navigationTitle("")
        .background(
            ZStack {
                Color(nsColor: .windowBackgroundColor)
                
                // Subtle ambient gradients
                GeometryReader { proxy in
                    Circle()
                        .fill(.blue.opacity(0.1))
                        .blur(radius: 80)
                        .offset(x: -100, y: -100)
                    
                    Circle()
                        .fill(.purple.opacity(0.1))
                        .blur(radius: 80)
                        .offset(x: proxy.size.width * 0.8, y: proxy.size.height * 0.5)
                }
            }
            .ignoresSafeArea()
        )
    }
}

struct MultiCurrencySummaryCard<G: View>: View {
    let title: LocalizedStringKey
    let amounts: [String: Double]
    let gradient: G
    let icon: String
    
    var body: some View {
        WuppyCard(padding: 16) {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    ZStack {
                        Circle()
                            .fill(.ultraThinMaterial)
                            .frame(width: 36, height: 36)
                        
                        gradient
                            .mask(Circle().frame(width: 36, height: 36))
                            .opacity(0.2)
                        
                        Image(systemName: icon)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(.primary)
                    }
                    
                    Spacer()
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                    
                    if amounts.isEmpty {
                        Text(0, format: .currency(code: "VND"))
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                    } else {
                        ForEach(amounts.sorted(by: { $0.key < $1.key }), id: \.key) { currency, amount in
                            Text(amount, format: .currency(code: currency))
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                        }
                    }
                }
            }
        }
    }
}
