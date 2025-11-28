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
    
    var totalIncome: Double {
        transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
    }
    
    var totalExpenses: Double {
        transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
    }
    
    var netResult: Double {
        totalIncome - totalExpenses
    }
    
    var totalDebtIOwe: Double {
        debts.filter { $0.role == .iOwe }.reduce(0) { $0 + $1.remainingAmount }
    }
    
    var totalDebtOwedToMe: Double {
        debts.filter { $0.role == .theyOweMe }.reduce(0) { $0 + $1.remainingAmount }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("dashboard_title")
                    .font(.largeTitle)
                    .bold()
                
                // Summary Cards
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                    SummaryCard(title: "total_income", amount: totalIncome, color: .green)
                    SummaryCard(title: "total_expenses", amount: totalExpenses, color: .red)
                    SummaryCard(title: "net_result", amount: netResult, color: netResult >= 0 ? .blue : .orange)
                }
                
                Divider()
                
                Text("debts_title")
                    .font(.title2)
                    .bold()
                
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 20) {
                    SummaryCard(title: "i_owe", amount: totalDebtIOwe, color: .red)
                    SummaryCard(title: "they_owe_me", amount: totalDebtOwedToMe, color: .green)
                }
                
                Divider()
                
                // Recent Activity or Charts could go here
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle("dashboard_title")
    }
}

struct SummaryCard: View {
    let title: LocalizedStringKey
    let amount: Double
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(amount, format: .currency(code: "VND"))
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(color)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(10)
        .shadow(radius: 1)
    }
}
