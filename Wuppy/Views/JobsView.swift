//
//  JobsView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI

import SwiftData

struct JobsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.locale) private var locale
    @Query(sort: \Job.createdDate, order: .reverse) private var jobs: [Job]
    @State private var showingAddJob = false
    @State private var selectedJob: Job?
    
    var body: some View {
        List {
            ForEach(jobs) { job in
                JobRowView(job: job)
                    .contentShape(Rectangle()) // Make entire row tappable for context menu
                    .contextMenu {
                        Button {
                            selectedJob = job
                            showingAddJob = true
                        } label: {
                            Label("edit", systemImage: "pencil")
                        }
                        
                        Button(role: .destructive) {
                            modelContext.delete(job)
                        } label: {
                            Label("delete", systemImage: "trash")
                        }
                        
                        Divider()
                        
                        if job.status != .paid && job.remainingAmount > 0 {
                            Button {
                                markAsPaid(job)
                            } label: {
                                Label("mark_as_paid", systemImage: "banknote.fill")
                            }
                        }
                        
                        Divider()
                        
                        Menu("job_status") {
                            ForEach(JobStatus.allCases, id: \.self) { status in
                                Button {
                                    job.status = status
                                } label: {
                                    if job.status == status {
                                        Label(status.localizedName, systemImage: "checkmark")
                                    } else {
                                        Text(status.localizedName)
                                    }
                                }
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
            }
            .onDelete(perform: deleteJobs)
        }
        .navigationTitle("jobs_title")
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
                Button(action: {
                    selectedJob = nil
                    showingAddJob = true
                }) {
                    Label("Add Job", systemImage: "plus")
                }
            }
        }
        .inspector(isPresented: $showingAddJob) {
            AddEditJobView(job: selectedJob)
            .id(selectedJob?.id)
            .environment(\.locale, locale)
            .inspectorColumnWidth(min: 400, ideal: 500, max: 600)
        }

    }
    
    private func deleteJobs(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(jobs[index])
            }
        }
    }
    
    private func markAsPaid(_ job: Job) {
        let transaction = Transaction(
            type: .income,
            category: "Job Payment",
            amount: job.remainingAmount,
            date: Date(),
            currency: job.currency,
            note: "Payment for \(job.title)"
        )
        transaction.job = job
        modelContext.insert(transaction)
        
        job.status = .paid
    }
}
