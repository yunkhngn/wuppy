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
                Button(action: { showingAddGoal = true }) {
                    Label("Add Goal", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddGoal) {
            NavigationStack {
                AddEditGoalView()
            }
            .environment(\.locale, locale)
        }
        .sheet(item: $selectedGoal) { goal in
             NavigationStack {
                 AddEditGoalView(goal: goal)
             }
             .environment(\.locale, locale)
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
