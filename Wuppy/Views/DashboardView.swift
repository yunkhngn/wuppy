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
            VStack(alignment: .leading, spacing: 20) {
                Text("dashboard_title")
                    .font(.largeTitle)
                    .bold()
                
                // Summary Cards
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))], spacing: 20) {
                    MultiCurrencySummaryCard(title: "total_income", amounts: incomeByCurrency, color: .green)
                    MultiCurrencySummaryCard(title: "total_expenses", amounts: expensesByCurrency, color: .red)
                    
                    // Net Result Calculation
                    let currencies = Set(incomeByCurrency.keys).union(expensesByCurrency.keys)
                    let netResult: [String: Double] = currencies.reduce(into: [:]) { dict, currency in
                        let income = incomeByCurrency[currency] ?? 0
                        let expense = expensesByCurrency[currency] ?? 0
                        dict[currency] = income - expense
                    }
                    
                    MultiCurrencySummaryCard(title: "net_result", amounts: netResult, color: .blue)
                }
                
                Divider()
                
                Text("debts_title")
                    .font(.title2)
                    .bold()
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 200))], spacing: 20) {
                    MultiCurrencySummaryCard(title: "i_owe", amounts: debtIOweByCurrency, color: .red)
                    MultiCurrencySummaryCard(title: "they_owe_me", amounts: debtOwedToMeByCurrency, color: .green)
                }
                
                Divider()
                
                // Recent Activity or Charts could go here
                AnalyticsChartsView()
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("dashboard_title")
    }
}

struct MultiCurrencySummaryCard: View {
    let title: LocalizedStringKey
    let amounts: [String: Double]
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            
            if amounts.isEmpty {
                Text(0, format: .currency(code: "VND"))
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(color)
            } else {
                ForEach(amounts.sorted(by: { $0.key < $1.key }), id: \.key) { currency, amount in
                    Text(amount, format: .currency(code: currency))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(color)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}
