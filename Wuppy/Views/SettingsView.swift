//
//  SettingsView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI

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
                Toggle("enable_icloud_sync", isOn: .constant(true))
            } header: {
                Text("sync_settings")
            }
        }
        .navigationTitle("settings_title")
    }
}
