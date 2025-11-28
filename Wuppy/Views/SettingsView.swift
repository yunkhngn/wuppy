//
//  SettingsView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("selectedLanguage") private var selectedLanguage: String = "system"
    
    var body: some View {
        Form {
            Section {
                Picker("language", selection: $selectedLanguage) {
                    Text("system_default").tag("system")
                    Text("english").tag("en")
                    Text("vietnamese").tag("vi")
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
