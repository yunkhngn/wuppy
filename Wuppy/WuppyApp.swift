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
    init() {
        NotificationManager.shared.requestAuthorization()
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            Job.self,
            TimeSession.self,
            Debt.self,
            Transaction.self,
            Goal.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @AppStorage("selectedLanguage") private var selectedLanguage: String = "system"
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.locale, locale)
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
}
