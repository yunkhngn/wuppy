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
    
    @AppStorage("defaultCurrency") private var defaultCurrency: String = "VND"
    
    @Query(sort: \JobCategory.name) private var categories: [JobCategory]
    
    @State private var title: String = ""
    @State private var clientName: String = ""
    @State private var jobDescription: String = ""
    @State private var selectedCategory: JobCategory?
    @State private var billingType: BillingType = .fixedPrice
    @State private var rate: Double?
    @State private var fixedPrice: Double?
    @State private var currency: String = "VND"
    @State private var status: JobStatus = .draft
    @State private var deadline: Date = Date().addingTimeInterval(86400 * 7)
    @State private var hasDeadline: Bool = false
    
    @Binding var isPresented: Bool
    
    var jobToEdit: Job?
    
    init(job: Job? = nil, isPresented: Binding<Bool>) {
        self.jobToEdit = job
        self._isPresented = isPresented
        if let job {
            _title = State(initialValue: job.title)
            _clientName = State(initialValue: job.clientName)
            _jobDescription = State(initialValue: job.jobDescription)
            _selectedCategory = State(initialValue: job.category)
            _billingType = State(initialValue: job.billingType)
            _rate = State(initialValue: job.rate)
            _fixedPrice = State(initialValue: job.fixedPrice)
            _currency = State(initialValue: job.currency)
            _status = State(initialValue: job.status)
            if let d = job.deadline {
                _deadline = State(initialValue: d)
                _hasDeadline = State(initialValue: true)
            }
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    Text(jobToEdit == nil ? "new_job" : "edit_job")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .padding(.top)
                    
                    // Job Details Section
                    WuppyCard(padding: 24) {
                        VStack(alignment: .leading, spacing: 20) {
                            WuppySectionHeader(title: "job_details", icon: "briefcase.fill")
                            
                            WuppyTextField(title: "job_title_label", text: $title, icon: "text.alignleft")
                            WuppyTextField(title: "client_name", text: $clientName, icon: "person.fill")
                            
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("job_type")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.secondary)
                                    
                                    HStack {
                                        Picker("", selection: $selectedCategory) {
                                            Text("none").tag(nil as JobCategory?)
                                            ForEach(categories) { category in
                                                Text(category.name).tag(category as JobCategory?)
                                            }
                                        }
                                        .labelsHidden()
                                        
                                        NavigationLink(destination: CategoryManagerView()) {
                                            Image(systemName: "plus.circle.fill")
                                                .foregroundStyle(.blue)
                                        }
                                        .buttonStyle(.plain)
                                    }
                                }
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("job_status")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.secondary)
                                    Picker("", selection: $status) {
                                        ForEach(JobStatus.allCases, id: \.self) { status in
                                            Text(status.localizedName).tag(status)
                                        }
                                    }
                                    .labelsHidden()
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Billing Section
                    WuppyCard(padding: 24) {
                        VStack(alignment: .leading, spacing: 20) {
                            WuppySectionHeader(title: "billing", icon: "banknote.fill")
                            
                            HStack(spacing: 16) {
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("billing_type")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.secondary)
                                    Picker("", selection: $billingType) {
                                        ForEach(BillingType.allCases, id: \.self) { type in
                                            Text(type.localizedName).tag(type)
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
                            }
                            
                            if billingType == .fixedPrice {
                                WuppyNumberField(title: "fixed_price", value: Binding(get: { fixedPrice ?? 0 }, set: { fixedPrice = $0 }), format: .currency(code: currency), icon: "dollarsign.circle")
                            } else {
                                WuppyNumberField(title: "hourly_rate", value: Binding(get: { rate ?? 0 }, set: { rate = $0 }), format: .currency(code: currency), icon: "clock")
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Dates Section
                    WuppyCard(padding: 24) {
                        VStack(alignment: .leading, spacing: 20) {
                            WuppySectionHeader(title: "dates", icon: "calendar")
                            
                            Toggle("has_deadline", isOn: $hasDeadline)
                                .toggleStyle(.switch)
                            
                            if hasDeadline {
                                DatePicker("deadline", selection: $deadline, displayedComponents: .date)
                                    .datePickerStyle(.compact)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal)
                    
                    // Notes Section
                    WuppyCard(padding: 24) {
                        VStack(alignment: .leading, spacing: 20) {
                            WuppySectionHeader(title: "notes", icon: "note.text")
                            
                            TextEditor(text: $jobDescription)
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
                    isPresented = false
                }
                .keyboardShortcut(.cancelAction)
                
                Spacer()
                
                Button("save") {
                    save()
                }
                .buttonStyle(.borderedProminent)
                .disabled(title.isEmpty || clientName.isEmpty)
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
            if jobToEdit == nil {
                currency = defaultCurrency
            }
        }
        .frame(minWidth: 500, minHeight: 600)
    }
    
    private func save() {
        if let job = jobToEdit {
            job.title = title
            job.clientName = clientName
            job.jobDescription = jobDescription
            job.category = selectedCategory
            job.billingType = billingType
            job.rate = rate
            job.fixedPrice = fixedPrice
            job.currency = currency
            job.status = status
            job.deadline = hasDeadline ? deadline : nil
        } else {
            let newJob = Job(
                title: title,
                clientName: clientName,
                jobDescription: jobDescription,
                category: selectedCategory,
                billingType: billingType,
                rate: rate,
                fixedPrice: fixedPrice,
                currency: currency,
                deadline: hasDeadline ? deadline : nil,
                status: status
            )
            modelContext.insert(newJob)
            NotificationManager.shared.scheduleJobDeadlineNotification(job: newJob)
        }
        }
        isPresented = false
    }
}
