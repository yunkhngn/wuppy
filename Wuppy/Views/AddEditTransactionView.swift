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
    
    @AppStorage("defaultCurrency") private var defaultCurrency: String = "VND"
    
    @Query(sort: \Job.createdDate, order: .reverse) private var jobs: [Job]
    @Query(sort: \Goal.createdDate, order: .reverse) private var goals: [Goal]
    
    @State private var type: TransactionType = .expense
    @State private var category: String = ""
    @State private var amount: Double = 0
    @State private var currency: String = "VND"
    @State private var date: Date = Date()
    @State private var note: String = ""
    @State private var selectedJob: Job?
    @State private var selectedGoal: Goal?
    
    var transactionToEdit: Transaction?
    
    init(transaction: Transaction? = nil) {
        self.transactionToEdit = transaction
        if let transaction {
            _type = State(initialValue: transaction.type)
            _category = State(initialValue: transaction.category)
            _amount = State(initialValue: transaction.amount)
            _currency = State(initialValue: transaction.currency)
            _date = State(initialValue: transaction.date)
            _note = State(initialValue: transaction.note)
            _selectedJob = State(initialValue: transaction.job)
            _selectedGoal = State(initialValue: transaction.goal)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    Text(transactionToEdit == nil ? "new_transaction" : "edit_transaction")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Details Section
                    WuppyCard {
                        VStack(alignment: .leading, spacing: 16) {
                            WuppySectionHeader(title: "details", icon: "doc.text.fill")
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("job_type") // This key might be wrong, should be "type" or "transaction_type"
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                                Picker("", selection: $type) {
                                    ForEach(TransactionType.allCases, id: \.self) { type in
                                        Text(type.localizedName).tag(type)
                                    }
                                }
                                .labelsHidden()
                                .pickerStyle(.segmented)
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
                            
                            WuppyNumberField(title: "amount", value: $amount, format: .currency(code: currency), icon: "banknote")
                            
                            WuppyTextField(title: "category", text: $category, icon: "tag.fill")
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("date")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                                DatePicker("", selection: $date, displayedComponents: [.date, .hourAndMinute])
                                    .labelsHidden()
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                    
                    .padding(.horizontal)
                    
                    // Job & Goal Link Section
                    WuppyCard {
                        VStack(alignment: .leading, spacing: 16) {
                            WuppySectionHeader(title: "links", icon: "link")
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("link_to_job")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                                Picker("", selection: $selectedJob) {
                                    Text("none").tag(nil as Job?)
                                    ForEach(jobs) { job in
                                        Text(job.title).tag(job as Job?)
                                    }
                                }
                                .labelsHidden()
                            }
                            
                            Divider()
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("link_to_goal")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundStyle(.secondary)
                                Picker("", selection: $selectedGoal) {
                                    Text("none").tag(nil as Goal?)
                                    ForEach(goals) { goal in
                                        Text(goal.name).tag(goal as Goal?)
                                    }
                                }
                                .labelsHidden()
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Notes Section
                    WuppyCard {
                        VStack(alignment: .leading, spacing: 16) {
                            WuppySectionHeader(title: "notes", icon: "note.text")
                            
                            TextEditor(text: $note)
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
                .disabled(amount <= 0 || category.isEmpty)
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
            if transactionToEdit == nil {
                currency = defaultCurrency
            }
        }
        .frame(minWidth: 400, minHeight: 500)
    }
    
    private func save() {
        if let transaction = transactionToEdit {
            transaction.type = type
            transaction.category = category
            transaction.amount = amount
            transaction.currency = currency
            transaction.date = date
            transaction.note = note
            transaction.job = selectedJob
            transaction.goal = selectedGoal
        } else {
            let newTransaction = Transaction(
                type: type,
                category: category,
                amount: amount,
                date: date,
                currency: currency,
                note: note
            )
            newTransaction.job = selectedJob
            newTransaction.goal = selectedGoal
            modelContext.insert(newTransaction)
        }
        dismiss()
    }
}
