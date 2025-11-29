//
//  WuppyApp.swift
//  Wuppy
//
//  Created by Khoa Nguyễn on 29/11/2025.
//

import SwiftUI
import SwiftData

@main
struct WuppyApp: App {
    let sharedModelContainer: ModelContainer
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "system"
    @AppStorage("appearance") private var appearance: String = "system"
    
    init() {
        let schema = Schema([
            Item.self,
            Job.self,
            JobCategory.self,
            TimeSession.self,
            Debt.self,
            Transaction.self,
            Goal.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        self.sharedModelContainer = {
            do {
                return try ModelContainer(for: schema, configurations: [modelConfiguration])
            } catch {
                print("Could not create ModelContainer: \(error)")
                print("Attempting to reset data store...")
                
                let fileManager = FileManager.default
                if let supportDir = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
                    let databaseURL = supportDir.appendingPathComponent("default.store")
                    try? fileManager.removeItem(at: databaseURL)
                    try? fileManager.removeItem(at: databaseURL.appendingPathExtension("shm"))
                    try? fileManager.removeItem(at: databaseURL.appendingPathExtension("wal"))
                }
                
                do {
                    return try ModelContainer(for: schema, configurations: [modelConfiguration])
                } catch {
                    fatalError("Could not create ModelContainer even after reset: \(error)")
                }
            }
        }()
        
        // Seed default categories if empty
        let context = sharedModelContainer.mainContext
        let descriptor = FetchDescriptor<JobCategory>()
        
        do {
            let existingCategories = try context.fetch(descriptor)
            if existingCategories.isEmpty {
                let defaults = ["Development", "Design", "Video Editing", "Music", "Other"]
                for name in defaults {
                    let category = JobCategory(name: name)
                    context.insert(category)
                }
                try? context.save()
            }
        } catch {
            print("Failed to seed data: \(error)")
        }
        
        // Request notification permission
        NotificationManager.shared.requestAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.locale, locale)
                .preferredColorScheme(colorScheme)
        }
        .modelContainer(sharedModelContainer)
        
        MenuBarExtra("Wuppy", systemImage: "banknote") {
            MenuBarView()
                .modelContainer(sharedModelContainer)
                .environment(\.locale, locale)
        }
        .menuBarExtraStyle(.window)
    }
    
    private var locale: Locale {
        if selectedLanguage == "system" {
            return Locale.current
        }
        return Locale(identifier: selectedLanguage)
    }
    
    private var colorScheme: ColorScheme? {
        switch appearance {
        case "light": return .light
        case "dark": return .dark
        default: return nil
        }
    }
}
