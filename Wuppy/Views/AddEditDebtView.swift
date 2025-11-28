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
    
    @AppStorage("defaultCurrency") private var defaultCurrency: String = "VND"
    
    @State private var personName: String = ""
    @State private var role: DebtRole = .iOwe
    @State private var principalAmount: Double = 0
    @State private var currency: String = "VND"
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
            _currency = State(initialValue: debt.currency)
            _interestRate = State(initialValue: debt.interestRate)
            if let d = debt.dueDate {
                _dueDate = State(initialValue: d)
                _hasDueDate = State(initialValue: true)
            }
            _notes = State(initialValue: debt.notes)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    Text(debtToEdit == nil ? "new_debt" : "edit_debt")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Details Section
                    WuppyCard {
                        VStack(alignment: .leading, spacing: 16) {
                            WuppySectionHeader(title: "details", icon: "doc.text.fill")
                            
                            WuppyTextField(title: "person_name", text: $personName, icon: "person.fill")
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("role")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                                Picker("", selection: $role) {
                                    ForEach(DebtRole.allCases, id: \.self) { role in
                                        Text(role.localizedName).tag(role)
                                    }
                                }
                                .labelsHidden()
                            }
                            
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
                            
                            WuppyNumberField(title: "amount", value: $principalAmount, format: .currency(code: currency), icon: "banknote")
                            
                            WuppyNumberField(title: "interest_rate", value: Binding(get: { interestRate ?? 0 }, set: { interestRate = $0 }), format: .number, icon: "percent")
                        }
                    }
                    .padding(.horizontal)
                    
                    // Dates Section
                    WuppyCard {
                        VStack(alignment: .leading, spacing: 16) {
                            WuppySectionHeader(title: "dates", icon: "calendar")
                            
                            Toggle("has_due_date", isOn: $hasDueDate)
                                .toggleStyle(.switch)
                            
                            if hasDueDate {
                                DatePicker("due_date", selection: $dueDate, displayedComponents: .date)
                                    .datePickerStyle(.graphical)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
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
            
            Divider()
            
            HStack {
                Button("cancel") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                
                Spacer()
                
                Button("save") {
                    save()
                }
                .buttonStyle(.borderedProminent)
                .disabled(personName.isEmpty || principalAmount <= 0)
                .keyboardShortcut(.defaultAction)
            }
            .padding()
            .background(.bar)
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
        .onAppear {
            if debtToEdit == nil {
                currency = defaultCurrency
            }
        }
        .frame(minWidth: 400, minHeight: 500)
    }
    
    private func save() {
        if let debt = debtToEdit {
            debt.personName = personName
            debt.role = role
            debt.principalAmount = principalAmount
            debt.currency = currency
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
                currency: currency,
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
