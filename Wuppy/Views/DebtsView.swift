//
//  DebtsView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI

import SwiftData

struct DebtsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.locale) private var locale
    @Query(sort: \Debt.createdDate, order: .reverse) private var debts: [Debt]
    @State private var showingAddDebt = false
    @State private var selectedDebt: Debt?
    
    var body: some View {
        List {
            ForEach(debts) { debt in
                DebtRowView(debt: debt)
                    .contentShape(Rectangle())
                    .contextMenu {
                        Button {
                            selectedDebt = debt
                            showingAddDebt = true
                        } label: {
                            Label("edit", systemImage: "pencil")
                        }
                        
                        if debt.remainingAmount > 0 {
                            Button {
                                settleDebt(debt)
                            } label: {
                                Label("settle_debt", systemImage: "checkmark.circle")
                            }
                        }
                        
                        Divider()
                        
                        Button(role: .destructive) {
                            modelContext.delete(debt)
                        } label: {
                            Label("delete", systemImage: "trash")
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            .onDelete(perform: deleteDebts)
        }
        .navigationTitle("debts_title")
        .scrollContentBackground(.hidden)
        .background(AppColors.background)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    selectedDebt = nil
                    showingAddDebt = true
                }) {
                    Label("Add Debt", systemImage: "plus")
                }
            }
        }
        .inspector(isPresented: $showingAddDebt) {
            AddEditDebtView(debt: selectedDebt)
            .id(selectedDebt?.id)
            .environment(\.locale, locale)
            .inspectorColumnWidth(min: 400, ideal: 500, max: 600)
        }
    }
    
    private func deleteDebts(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(debts[index])
            }
        }
    }
    
    private func settleDebt(_ debt: Debt) {
        let transactionType: TransactionType = debt.role == .iOwe ? .expense : .income
        let category = debt.role == .iOwe ? "Debt Repayment" : "Debt Collection"
        
        let transaction = Transaction(
            type: transactionType,
            category: category,
            amount: debt.remainingAmount,
            date: Date(),
            currency: debt.currency,
            note: "Settlement for \(debt.personName)"
        )
        modelContext.insert(transaction)
        
        debt.lastPaymentDate = Date()
    }
}
