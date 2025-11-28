//
//  TransactionsView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI

import SwiftData

struct TransactionsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    @State private var showingAddTransaction = false
    @State private var selectedTransaction: Transaction?
    
    var body: some View {
        List(selection: $selectedTransaction) {
            ForEach(transactions) { transaction in
                NavigationLink(value: transaction) {
                    TransactionRowView(transaction: transaction)
                }
            }
            .onDelete(perform: deleteTransactions)
        }
        .navigationTitle("transactions_title")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingAddTransaction = true }) {
                    Label("Add Transaction", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddTransaction) {
            NavigationStack {
                AddEditTransactionView()
            }
        }
        .sheet(item: $selectedTransaction) { transaction in
             NavigationStack {
                 AddEditTransactionView(transaction: transaction)
             }
        }
    }
    
    private func deleteTransactions(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(transactions[index])
            }
        }
    }
}
