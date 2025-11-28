//
//  AnalyticsChartsView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI
import Charts
import SwiftData

struct AnalyticsChartsView: View {
    @Query private var transactions: [Transaction]
    @Query private var jobs: [Job]
    
    var incomeByMonth: [(date: Date, amount: Double)] {
        let income = transactions.filter { $0.type == .income }
        let grouped = Dictionary(grouping: income) { (transaction) -> Date in
            let components = Calendar.current.dateComponents([.year, .month], from: transaction.date)
            return Calendar.current.date(from: components) ?? Date()
        }
        return grouped.map { (key, value) in
            (date: key, amount: value.reduce(0) { $0 + $1.amount })
        }.sorted { $0.date < $1.date }
    }
    
    var expensesByCategory: [(category: String, amount: Double)] {
        let expenses = transactions.filter { $0.type == .expense }
        let grouped = Dictionary(grouping: expenses) { $0.category }
        return grouped.map { (key, value) in
            (category: key, amount: value.reduce(0) { $0 + $1.amount })
        }.sorted { $0.amount > $1.amount }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            Text("Analytics")
                .font(.title2)
                .bold()
            
            if !incomeByMonth.isEmpty {
                VStack(alignment: .leading) {
                    Text("Income Over Time")
                        .font(.headline)
                    Chart {
                        ForEach(incomeByMonth, id: \.date) { item in
                            LineMark(
                                x: .value("Month", item.date, unit: .month),
                                y: .value("Income", item.amount)
                            )
                            .interpolationMethod(.catmullRom)
                            
                            AreaMark(
                                x: .value("Month", item.date, unit: .month),
                                y: .value("Income", item.amount)
                            )
                            .interpolationMethod(.catmullRom)
                            .foregroundStyle(.linearGradient(colors: [.blue.opacity(0.3), .blue.opacity(0.0)], startPoint: .top, endPoint: .bottom))
                        }
                    }
                    .frame(height: 200)
                }
            }
            
            if !expensesByCategory.isEmpty {
                VStack(alignment: .leading) {
                    Text("Expenses by Category")
                        .font(.headline)
                    Chart {
                        ForEach(expensesByCategory, id: \.category) { item in
                            BarMark(
                                x: .value("Category", item.category),
                                y: .value("Amount", item.amount)
                            )
                            .foregroundStyle(by: .value("Category", item.category))
                        }
                    }
                    .frame(height: 200)
                }
            }
        }
        .padding()
        .background(Color(nsColor: .controlBackgroundColor))
        .cornerRadius(12)
    }
}
