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
                        } label: {
                            Label("edit", systemImage: "pencil")
                        }
                        
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
