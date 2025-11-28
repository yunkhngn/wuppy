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
    
    @AppStorage("defaultCurrency") private var defaultCurrency: String = "VND"
    
    @State private var name: String = ""
    @State private var targetAmount: Double = 0
    @State private var currentAmount: Double = 0
    @State private var currency: String = "VND"
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
            _currency = State(initialValue: goal.currency)
            if let d = goal.targetDate {
                _targetDate = State(initialValue: d)
                _hasTargetDate = State(initialValue: true)
            }
            _notes = State(initialValue: goal.notes)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                Text(goalToEdit == nil ? "new_goal" : "edit_goal")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
                
                // Details Section
                WuppyCard {
                    VStack(alignment: .leading, spacing: 16) {
                        WuppySectionHeader(title: "details", icon: "target")
                        
                        WuppyTextField(title: "goal_name", text: $name, icon: "flag.fill")
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("currency")
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundStyle(.secondary)
                            Picker("", selection: $currency) {
                                Text("VND").tag("VND")
                                Text("USD").tag("USD")
                            }
                            .labelsHidden()
                            .pickerStyle(.segmented)
                        }
                        
                        WuppyNumberField(title: "target_amount", value: $targetAmount, format: .currency(code: currency), icon: "banknote")
                        
                        WuppyNumberField(title: "current_saved", value: $currentAmount, format: .currency(code: currency), icon: "banknote.fill")
                    }
                }
                .padding(.horizontal)
                
                // Dates Section
                WuppyCard {
                    VStack(alignment: .leading, spacing: 16) {
                        WuppySectionHeader(title: "dates", icon: "calendar")
                        
                        Toggle("has_target_date", isOn: $hasTargetDate)
                            .toggleStyle(.switch)
                        
                        if hasTargetDate {
                            DatePicker("target_date", selection: $targetDate, displayedComponents: .date)
                                .datePickerStyle(.graphical)
                        }
                    }
                }
                .padding(.horizontal)
                
                // Notes Section
                WuppyCard {
                    VStack(alignment: .leading, spacing: 16) {
                        WuppySectionHeader(title: "notes", icon: "note.text")
                        
                        TextEditor(text: $notes)
                            .frame(minHeight: 100)
                            .padding(8)
                            .background(Color(nsColor: .controlBackgroundColor))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                            )
                    }
                }
                .padding(.horizontal)
                
                Spacer().frame(height: 20)
            }
        }
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
            ToolbarItem(placement: .cancellationAction) {
                Button("cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("save") {
                    save()
                }
                .buttonStyle(.borderedProminent)
                .disabled(name.isEmpty || targetAmount <= 0)
            }
        }
        .onAppear {
            if goalToEdit == nil {
                currency = defaultCurrency
            }
        }
        .frame(minWidth: 400, minHeight: 500)
    }
    
    private func save() {
        if let goal = goalToEdit {
            goal.name = name
            goal.targetAmount = targetAmount
            goal.currentAmount = currentAmount
            goal.currency = currency
            goal.targetDate = hasTargetDate ? targetDate : nil
            goal.notes = notes
        } else {
            let newGoal = Goal(
                name: name,
                targetAmount: targetAmount,
                currentAmount: currentAmount,
                currency: currency,
                targetDate: hasTargetDate ? targetDate : nil,
                notes: notes
            )
            modelContext.insert(newGoal)
        }
        dismiss()
    }
}
