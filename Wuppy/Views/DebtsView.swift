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
        List(selection: $selectedDebt) {
            ForEach(debts) { debt in
                NavigationLink(value: debt) {
                    DebtRowView(debt: debt)
                }
            }
            .onDelete(perform: deleteDebts)
        }
        .navigationTitle("debts_title")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingAddDebt = true }) {
                    Label("Add Debt", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddDebt) {
            NavigationStack {
                AddEditDebtView()
            }
            .environment(\.locale, locale)
        }
        .sheet(item: $selectedDebt) { debt in
             NavigationStack {
                 AddEditDebtView(debt: debt)
             }
             .environment(\.locale, locale)
        }
    }
    
    private func deleteDebts(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(debts[index])
            }
        }
    }
}
