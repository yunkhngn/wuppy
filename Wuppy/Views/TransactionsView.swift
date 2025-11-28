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
    @Environment(\.locale) private var locale
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]
    @State private var showingAddTransaction = false
    @State private var selectedTransaction: Transaction?
    
    var body: some View {
        List {
            ForEach(transactions) { transaction in
                TransactionRowView(transaction: transaction)
                    .contentShape(Rectangle())
                    .contextMenu {
                        Button {
                            selectedTransaction = transaction
                            showingAddTransaction = true
                        } label: {
                            Label("edit", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive) {
                            modelContext.delete(transaction)
                        } label: {
                            Label("delete", systemImage: "trash")
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            .onDelete(perform: deleteTransactions)
        }
        .navigationTitle("transactions_title")
        .scrollContentBackground(.hidden)
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
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    selectedTransaction = nil
                    showingAddTransaction = true
                }) {
                    Label("Add Transaction", systemImage: "plus")
                }
            }
        }
        .inspector(isPresented: $showingAddTransaction) {
            NavigationStack {
                AddEditTransactionView(transaction: selectedTransaction)
            }
            .id(selectedTransaction?.id)
            .environment(\.locale, locale)
            .inspectorColumnWidth(min: 400, ideal: 500, max: 600)
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
