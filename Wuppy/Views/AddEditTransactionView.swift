//
//  AddEditTransactionView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI
import SwiftData

struct AddEditTransactionView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query(sort: \Job.createdDate, order: .reverse) private var jobs: [Job]
    
    @State private var type: TransactionType = .expense
    @State private var category: String = ""
    @State private var amount: Double = 0
    @State private var date: Date = Date()
    @State private var note: String = ""
    @State private var selectedJob: Job?
    
    var transactionToEdit: Transaction?
    
    init(transaction: Transaction? = nil) {
        self.transactionToEdit = transaction
        if let transaction {
            _type = State(initialValue: transaction.type)
            _category = State(initialValue: transaction.category)
            _amount = State(initialValue: transaction.amount)
            _date = State(initialValue: transaction.date)
            _note = State(initialValue: transaction.note)
            _selectedJob = State(initialValue: transaction.job)
        }
    }
    
    var body: some View {
        Form {
            Section("details") {
                Picker("job_type", selection: $type) {
                    ForEach(TransactionType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                .pickerStyle(.segmented)
                
                TextField("amount", value: $amount, format: .currency(code: "VND"))
                
                TextField("category", text: $category) // Could be a picker with predefined categories later
                
                DatePicker("date", selection: $date, displayedComponents: [.date, .hourAndMinute])
            }
            
            Section("link_to_job") {
                Picker("jobs_title", selection: $selectedJob) {
                    Text("none").tag(nil as Job?)
                    ForEach(jobs) { job in
                        Text(job.title).tag(job as Job?)
                    }
                }
            }
            
            Section("notes") {
                TextEditor(text: $note)
                    .frame(minHeight: 100)
            }
        }
        .formStyle(.grouped)
        .navigationTitle(transactionToEdit == nil ? "new_transaction" : "edit_transaction")
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
                .disabled(amount <= 0 || category.isEmpty)
            }
        }
        .padding()
        .frame(minWidth: 400, minHeight: 400)
    }
    
    private func save() {
        if let transaction = transactionToEdit {
            transaction.type = type
            transaction.category = category
            transaction.amount = amount
            transaction.date = date
            transaction.note = note
            transaction.job = selectedJob
        } else {
            let newTransaction = Transaction(
                type: type,
                category: category,
                amount: amount,
                date: date,
                note: note
            )
            newTransaction.job = selectedJob
            modelContext.insert(newTransaction)
        }
        dismiss()
    }
}
