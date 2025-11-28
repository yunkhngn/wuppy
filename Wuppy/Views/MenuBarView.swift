//
//  MenuBarView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI
import SwiftData

struct MenuBarView: View {
    @Query private var transactions: [Transaction]
    @Query(sort: \Job.deadline, order: .forward) private var jobs: [Job]
    @Query(sort: \Debt.dueDate, order: .forward) private var debts: [Debt]
    
    var availableMoney: Double {
        let income = transactions.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
        let expense = transactions.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
        return income - expense
    }
    
    var nearestDeadline: Job? {
        jobs.first { $0.deadline != nil && $0.deadline! >= Date() }
    }
    
    var nearestDebtDue: Debt? {
        debts.first { $0.dueDate != nil && $0.dueDate! >= Date() }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Wuppy")
                .font(.headline)
            
            Divider()
            
            HStack {
                Text("Available:")
                Spacer()
                Text(availableMoney, format: .currency(code: "VND"))
                    .fontWeight(.bold)
            }
            
            if let job = nearestDeadline, let deadline = job.deadline {
                HStack {
                    Text("Next Deadline:")
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(job.title)
                            .lineLimit(1)
                        Text(deadline, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            if let debt = nearestDebtDue, let dueDate = debt.dueDate {
                HStack {
                    Text("Debt Due:")
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(debt.personName)
                            .lineLimit(1)
                        Text(dueDate, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            
            Divider()
            
            HStack {
                Button("Add Income") {
                    // In a real app, this might open the main app with a specific sheet
                    // For now, we can't easily open a sheet from MenuBarExtra in the main window without URL schemes or other tricks
                    // We'll just open the app
                    openApp()
                }
                
                Button("Add Expense") {
                    openApp()
                }
            }
            
            Button("Open Wuppy") {
                openApp()
            }
            .keyboardShortcut("o")
            
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
        .padding()
        .frame(width: 250)
    }
    
    private func openApp() {
        NSApp.activate(ignoringOtherApps: true)
    }
}
