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
        List(selection: $selectedJob) {
            ForEach(jobs) { job in
                NavigationLink(value: job) {
                    JobRowView(job: job)
                }
            }
            .onDelete(perform: deleteJobs)
        }
        .navigationTitle("jobs_title")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: { showingAddJob = true }) {
                    Label("Add Job", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddJob) {
            NavigationStack {
                AddEditJobView()
            }
            .environment(\.locale, locale)
        }
        .navigationDestination(for: Job.self) { job in
            JobDetailView(job: job)
        }
    }
    
    private func deleteJobs(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(jobs[index])
            }
        }
    }
}
