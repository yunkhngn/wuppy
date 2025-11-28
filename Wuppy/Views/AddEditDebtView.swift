//
//  AddEditDebtView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI
import SwiftData

struct AddEditDebtView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var personName: String = ""
    @State private var role: DebtRole = .iOwe
    @State private var principalAmount: Double = 0
    @State private var interestRate: Double?
    @State private var dueDate: Date = Date().addingTimeInterval(86400 * 30)
    @State private var hasDueDate: Bool = false
    @State private var notes: String = ""
    
    var debtToEdit: Debt?
    
    init(debt: Debt? = nil) {
        self.debtToEdit = debt
        if let debt {
            _personName = State(initialValue: debt.personName)
            _role = State(initialValue: debt.role)
            _principalAmount = State(initialValue: debt.principalAmount)
            _interestRate = State(initialValue: debt.interestRate)
            if let d = debt.dueDate {
                _dueDate = State(initialValue: d)
                _hasDueDate = State(initialValue: true)
            }
            _notes = State(initialValue: debt.notes)
        }
    }
    
    var body: some View {
        Form {
            Section("Details") {
                TextField("Person Name", text: $personName)
                Picker("Role", selection: $role) {
                    ForEach(DebtRole.allCases, id: \.self) { role in
                        Text(role.rawValue).tag(role)
                    }
                }
                TextField("Amount", value: $principalAmount, format: .currency(code: "VND"))
                TextField("Interest Rate (%)", value: $interestRate, format: .number)
            }
            
            Section("Dates") {
                Toggle("Has Due Date", isOn: $hasDueDate)
                if hasDueDate {
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                }
            }
            
            Section("Notes") {
                TextEditor(text: $notes)
                    .frame(minHeight: 100)
            }
        }
        .formStyle(.grouped)
        .navigationTitle(debtToEdit == nil ? "New Debt" : "Edit Debt")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    save()
                }
                .disabled(personName.isEmpty || principalAmount <= 0)
            }
        }
        .padding()
        .frame(minWidth: 400, minHeight: 400)
    }
    
    private func save() {
        if let debt = debtToEdit {
            debt.personName = personName
            debt.role = role
            debt.principalAmount = principalAmount
            debt.interestRate = interestRate
            debt.dueDate = hasDueDate ? dueDate : nil
            debt.notes = notes
            // Recalculate remaining if needed, but for now assuming edit doesn't reset payments
            // If principal changed, we might need logic to adjust remaining. 
            // For simplicity, if principal changes, we adjust remaining by the difference.
            let diff = principalAmount - debt.principalAmount
            debt.remainingAmount += diff
        } else {
            let newDebt = Debt(
                personName: personName,
                role: role,
                principalAmount: principalAmount,
                interestRate: interestRate,
                dueDate: hasDueDate ? dueDate : nil,
                remainingAmount: principalAmount,
                notes: notes
            )
            modelContext.insert(newDebt)
            NotificationManager.shared.scheduleDebtDueDateNotification(debt: newDebt)
        }
        dismiss()
    }
}
