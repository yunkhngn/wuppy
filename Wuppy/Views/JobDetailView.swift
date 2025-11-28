//
//  JobDetailView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI

struct JobDetailView: View {
    @Environment(\.locale) private var locale
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
                    InfoRow(label: "job_type", value: job.jobType.rawValue)
                    InfoRow(label: "billing", value: job.billingType.rawValue)
                    
                    if job.billingType == .fixedPrice {
                        InfoRow(label: "fixed_price", value: (job.fixedPrice ?? 0).formatted(.currency(code: "VND")))
                    } else {
                        InfoRow(label: "hourly_rate", value: (job.rate ?? 0).formatted(.currency(code: "VND")) + "/hr")
                    }
                    
                    if let deadline = job.deadline {
                        InfoRow(label: "deadline", value: deadline.formatted(date: .long, time: .omitted))
                    }
                }
                
                Divider()
                
                // Description
                if !job.jobDescription.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("description")
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
                Button("edit") {
                    showingEditJob = true
                }
            }
        }
        .sheet(isPresented: $showingEditJob) {
            NavigationStack {
                AddEditJobView(job: job)
            }
            .environment(\.locale, locale)
        }
    }
}

struct InfoRow: View {
    let label: LocalizedStringKey
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
