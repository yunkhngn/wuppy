//
//  JobDetailView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI

struct JobDetailView: View {
    @Bindable var job: Job
    @State private var showingEditJob = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                HStack {
                    VStack(alignment: .leading) {
                        Text(job.title)
                            .font(.title)
                            .bold()
                        Text(job.clientName)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    StatusBadge(status: job.status)
                        .scaleEffect(1.5)
                }
                
                Divider()
                
                // Info Grid
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    InfoRow(label: "Type", value: job.jobType.rawValue)
                    InfoRow(label: "Billing", value: job.billingType.rawValue)
                    
                    if job.billingType == .fixedPrice {
                        InfoRow(label: "Price", value: (job.fixedPrice ?? 0).formatted(.currency(code: "VND")))
                    } else {
                        InfoRow(label: "Rate", value: (job.rate ?? 0).formatted(.currency(code: "VND")) + "/hr")
                    }
                    
                    if let deadline = job.deadline {
                        InfoRow(label: "Deadline", value: deadline.formatted(date: .long, time: .omitted))
                    }
                }
                
                Divider()
                
                // Description
                if !job.jobDescription.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        Text(job.jobDescription)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Spacer()
            }
            .padding()
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Edit") {
                    showingEditJob = true
                }
            }
        }
        .sheet(isPresented: $showingEditJob) {
            NavigationStack {
                AddEditJobView(job: job)
            }
        }
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.body)
        }
    }
}
