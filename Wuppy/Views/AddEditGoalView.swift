//
//  AddEditGoalView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI
import SwiftData

struct AddEditGoalView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String = ""
    @State private var targetAmount: Double = 0
    @State private var currentAmount: Double = 0
    @State private var targetDate: Date = Date().addingTimeInterval(86400 * 365)
    @State private var hasTargetDate: Bool = false
    @State private var notes: String = ""
    
    var goalToEdit: Goal?
    
    init(goal: Goal? = nil) {
        self.goalToEdit = goal
        if let goal {
            _name = State(initialValue: goal.name)
            _targetAmount = State(initialValue: goal.targetAmount)
            _currentAmount = State(initialValue: goal.currentAmount)
            if let d = goal.targetDate {
                _targetDate = State(initialValue: d)
                _hasTargetDate = State(initialValue: true)
            }
            _notes = State(initialValue: goal.notes)
        }
    }
    
    var body: some View {
        Form {
            Section("details") {
                TextField("goal_name", text: $name)
                TextField("target_amount", value: $targetAmount, format: .currency(code: "VND"))
                TextField("current_saved", value: $currentAmount, format: .currency(code: "VND"))
            }
            
            Section("dates") {
                Toggle("has_target_date", isOn: $hasTargetDate)
                if hasTargetDate {
                    DatePicker("target_date", selection: $targetDate, displayedComponents: .date)
                }
            }
            
            Section("notes") {
                TextEditor(text: $notes)
                    .frame(minHeight: 100)
            }
        }
        .formStyle(.grouped)
        .navigationTitle(goalToEdit == nil ? "new_goal" : "edit_goal")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("save") {
                    save()
                }
                .disabled(name.isEmpty || targetAmount <= 0)
            }
        }
        .padding()
        .frame(minWidth: 400, minHeight: 400)
    }
    
    private func save() {
        if let goal = goalToEdit {
            goal.name = name
            goal.targetAmount = targetAmount
            goal.currentAmount = currentAmount
            goal.targetDate = hasTargetDate ? targetDate : nil
            goal.notes = notes
        } else {
            let newGoal = Goal(
                name: name,
                targetAmount: targetAmount,
                currentAmount: currentAmount,
                targetDate: hasTargetDate ? targetDate : nil,
                notes: notes
            )
            modelContext.insert(newGoal)
        }
        dismiss()
    }
}
