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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text(Date(), format: .dateTime.weekday(.wide).day().month())
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
                    
                    // Net Result Calculation
                    let currencies = Set(incomeByCurrency.keys).union(expensesByCurrency.keys)
                    let netResult: [String: Double] = currencies.reduce(into: [:]) { dict, currency in
                        let income = incomeByCurrency[currency] ?? 0
                        let expense = expensesByCurrency[currency] ?? 0
                        dict[currency] = income - expense
                    }
                    
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
                        MultiCurrencySummaryCard(title: "i_owe", amounts: debtIOweByCurrency, gradient: WuppyColor.expenseGradient.opacity(0.8), icon: "hand.thumbsdown.fill")
                        MultiCurrencySummaryCard(title: "they_owe_me", amounts: debtOwedToMeByCurrency, gradient: WuppyColor.incomeGradient.opacity(0.8), icon: "hand.thumbsup.fill")
                    }
                    .padding(.horizontal)
                }
                
                // Charts Section
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Image(systemName: "chart.xyaxis.line")
                            .foregroundStyle(.purple)
                        Text("Analytics") // Need localization key if not exists
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
        .navigationTitle("") // Hide default title as we have custom header
        .background(Color(nsColor: .windowBackgroundColor))
    }
}

struct MultiCurrencySummaryCard: View {
    let title: LocalizedStringKey
    let amounts: [String: Double]
    let gradient: LinearGradient
    let icon: String
    
    var body: some View {
        WuppyCard(padding: 0) {
            ZStack(alignment: .topLeading) {
                gradient
                    .opacity(0.15)
                
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: icon)
                            .font(.title2)
                            .foregroundStyle(.secondary)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                        
                        Spacer()
                        
                        Text(title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundStyle(.secondary)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
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
                .padding()
            }
        }
    }
}
