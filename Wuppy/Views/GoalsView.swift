//
//  GoalsView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI

import SwiftData

struct GoalsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.locale) private var locale
    @Query(sort: \Goal.createdDate, order: .reverse) private var goals: [Goal]
    @State private var showingAddGoal = false
    @State private var selectedGoal: Goal?
    
    var body: some View {
        List {
            ForEach(goals) { goal in
                GoalRowView(goal: goal)
                    .contentShape(Rectangle())
                    .contextMenu {
                        Button {
                            selectedGoal = goal
                            showingAddGoal = true
                        } label: {
                            Label("edit", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive) {
                            modelContext.delete(goal)
                        } label: {
                            Label("delete", systemImage: "trash")
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            .onDelete(perform: deleteGoals)
        }
        .navigationTitle("goals_title")
        .scrollContentBackground(.hidden)
        .background(AppColors.background)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    selectedGoal = nil
                    showingAddGoal = true
                }) {
                    Label("Add Goal", systemImage: "plus")
                }
            }
        }
        .inspector(isPresented: $showingAddGoal) {
            AddEditGoalView(goal: selectedGoal)
            .id(selectedGoal?.id)
            .environment(\.locale, locale)
            .inspectorColumnWidth(min: 400, ideal: 500, max: 600)
        }
    }
    
    private func deleteGoals(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(goals[index])
            }
        }
    }
}
