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
            JobCategory.self, // Added JobCategory
            TimeSession.self,
            Debt.self,
            Transaction.self,
            Goal.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            sharedModelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            // Seed default categories if empty
            let context = sharedModelContainer.mainContext
            let descriptor = FetchDescriptor<JobCategory>()
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
            fatalError("Could not create ModelContainer: \(error)")
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
