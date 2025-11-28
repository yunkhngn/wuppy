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
    @Query(sort: \Goal.createdDate, order: .reverse) private var goals: [Goal]
    @State private var showingAddGoal = false
    @State private var selectedGoal: Goal?
    
    var body: some View {
        List(selection: $selectedGoal) {
            ForEach(goals) { goal in
                NavigationLink(value: goal) {
                    GoalRowView(goal: goal)
                }
            }
            .onDelete(perform: deleteGoals)
        }
        .navigationTitle("goals_title")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingAddGoal = true }) {
                    Label("Add Goal", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddGoal) {
            NavigationStack {
                AddEditGoalView()
            }
        }
        .sheet(item: $selectedGoal) { goal in
             NavigationStack {
                 AddEditGoalView(goal: goal)
             }
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
