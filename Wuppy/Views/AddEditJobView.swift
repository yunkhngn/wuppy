//
//  AddEditJobView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI
import SwiftData

struct AddEditJobView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title: String = ""
    @State private var clientName: String = ""
    @State private var jobDescription: String = ""
    @State private var jobType: JobType = .other
    @State private var billingType: BillingType = .fixedPrice
    @State private var rate: Double?
    @State private var fixedPrice: Double?
    @State private var status: JobStatus = .draft
    @State private var deadline: Date = Date().addingTimeInterval(86400 * 7)
    @State private var hasDeadline: Bool = false
    
    var jobToEdit: Job?
    
    init(job: Job? = nil) {
        self.jobToEdit = job
        if let job {
            _title = State(initialValue: job.title)
            _clientName = State(initialValue: job.clientName)
            _jobDescription = State(initialValue: job.jobDescription)
            _jobType = State(initialValue: job.jobType)
            _billingType = State(initialValue: job.billingType)
            _rate = State(initialValue: job.rate)
            _fixedPrice = State(initialValue: job.fixedPrice)
            _status = State(initialValue: job.status)
            if let d = job.deadline {
                _deadline = State(initialValue: d)
                _hasDeadline = State(initialValue: true)
            }
        }
    }
    
    var body: some View {
        Form {
            Section("job_details") {
                TextField("job_title_label", text: $title)
                TextField("client_name", text: $clientName)
                Picker("job_type", selection: $jobType) {
                    ForEach(JobType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                Picker("job_status", selection: $status) {
                    ForEach(JobStatus.allCases, id: \.self) { status in
                        Text(status.rawValue).tag(status)
                    }
                }
            }
            
            Section("billing") {
                Picker("billing_type", selection: $billingType) {
                    ForEach(BillingType.allCases, id: \.self) { type in
                        Text(type.rawValue).tag(type)
                    }
                }
                
                if billingType == .fixedPrice {
                    TextField("fixed_price", value: $fixedPrice, format: .currency(code: "VND"))
                } else {
                    TextField("hourly_rate", value: $rate, format: .currency(code: "VND"))
                }
            }
            
            Section("dates") {
                Toggle("has_deadline", isOn: $hasDeadline)
                if hasDeadline {
                    DatePicker("deadline", selection: $deadline, displayedComponents: .date)
                }
            }
            
            Section("notes") {
                TextEditor(text: $jobDescription)
                    .frame(minHeight: 100)
            }
        }
        .formStyle(.grouped)
        .navigationTitle(jobToEdit == nil ? "new_job" : "edit_job")
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
                .disabled(title.isEmpty || clientName.isEmpty)
            }
        }
        .padding()
        .frame(minWidth: 400, minHeight: 500)
    }
    
    private func save() {
        if let job = jobToEdit {
            job.title = title
            job.clientName = clientName
            job.jobDescription = jobDescription
            job.jobType = jobType
            job.billingType = billingType
            job.rate = rate
            job.fixedPrice = fixedPrice
            job.status = status
            job.deadline = hasDeadline ? deadline : nil
        } else {
            let newJob = Job(
                title: title,
                clientName: clientName,
                jobDescription: jobDescription,
                jobType: jobType,
                billingType: billingType,
                rate: rate,
                fixedPrice: fixedPrice,
                deadline: hasDeadline ? deadline : nil,
                status: status
            )
            modelContext.insert(newJob)
            NotificationManager.shared.scheduleJobDeadlineNotification(job: newJob)
        }
        dismiss()
    }
}
