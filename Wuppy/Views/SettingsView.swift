//
//  SettingsView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "system"
    @AppStorage("defaultCurrency") private var defaultCurrency: String = "VND"
    @AppStorage("appearance") private var appearance: String = "system"
    
    var body: some View {
        Form {
            Section {
                Picker("language", selection: $selectedLanguage) {
                    Text("system_default").tag("system")
                    Text("english").tag("en")
                    Text("vietnamese").tag("vi")
                }
                
                Picker("default_currency", selection: $defaultCurrency) {
                    Text("VND").tag("VND")
                    Text("USD").tag("USD")
                }
                
                Picker("appearance", selection: $appearance) {
                    Text("system_default").tag("system")
                    Text("light").tag("light")
                    Text("dark").tag("dark")
                }
            } header: {
                Text("general_settings")
            }
            
            Section {
                NavigationLink(destination: CategoryManagerView()) {
                    Label("manage_categories", systemImage: "tag.fill")
                }
            } header: {
                Text("categories")
            }
            
            Section {
                Toggle("enable_icloud_sync", isOn: .constant(true))
            } header: {
                Text("sync_settings")
            }
            
            Section {
                Button(role: .destructive) {
                    showingDeleteAlert = true
                } label: {
                    Label("delete_all_data", systemImage: "trash")
                }
            } header: {
                Text("data_management")
            }
        }
        .navigationTitle("settings_title")
        .alert("delete_all_data_confirmation", isPresented: $showingDeleteAlert) {
            Button("cancel", role: .cancel) { }
            Button("delete", role: .destructive) {
                deleteAllData()
            }
        } message: {
            Text("delete_all_data_message")
        }
    }
    
    @State private var showingDeleteAlert = false
    @Environment(\.modelContext) private var modelContext
    
    private func deleteAllData() {
        // Manual delete loop to ensure compatibility
        do {
            let transactions = try modelContext.fetch(FetchDescriptor<Transaction>())
            for item in transactions { modelContext.delete(item) }
            
            let jobs = try modelContext.fetch(FetchDescriptor<Job>())
            for item in jobs { modelContext.delete(item) }
            
            let debts = try modelContext.fetch(FetchDescriptor<Debt>())
            for item in debts { modelContext.delete(item) }
            
            let goals = try modelContext.fetch(FetchDescriptor<Goal>())
            for item in goals { modelContext.delete(item) }
            
            let categories = try modelContext.fetch(FetchDescriptor<JobCategory>())
            for item in categories { modelContext.delete(item) }
            
            let sessions = try modelContext.fetch(FetchDescriptor<TimeSession>())
            for item in sessions { modelContext.delete(item) }
            
            try modelContext.save()
        } catch {
            print("Failed to delete data: \(error)")
        }
    }
}
