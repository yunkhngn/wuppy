//
//  SettingsView.swift
//  Wuppy
//
//  Created by Wuppy AI on 29/11/2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        Form {
            Section {
                Toggle("enable_icloud_sync", isOn: .constant(true))
            } header: {
                Text("settings_title")
            }
        }
        .navigationTitle("settings_title")
    }
}
