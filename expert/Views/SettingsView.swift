//
//  SettingsView.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import SwiftUI

struct SettingsView: View {
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var autoRefreshEnabled = true
    
    var body: some View {
        NavigationStack {
            List {
                Section("General") {
                    Toggle(isOn: $notificationsEnabled) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(.blue)
                            Text("Notifications")
                        }
                    }
                    
                    Toggle(isOn: $darkModeEnabled) {
                        HStack {
                            Image(systemName: "moon.fill")
                                .foregroundColor(.indigo)
                            Text("Dark Mode")
                        }
                    }
                    
                    Toggle(isOn: $autoRefreshEnabled) {
                        HStack {
                            Image(systemName: "arrow.clockwise")
                                .foregroundColor(.green)
                            Text("Auto Refresh Token")
                        }
                    }
                }
                
                Section("About") {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.blue)
                        Text("Version")
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(.secondary)
                    }
                    
                    HStack {
                        Image(systemName: "building.2.fill")
                            .foregroundColor(.orange)
                        Text("Environment")
                        Spacer()
                        Text("Development")
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Configuration") {
                    HStack {
                        Image(systemName: "server.rack")
                            .foregroundColor(.purple)
                        Text("OAuth Server")
                        Spacer()
                        Text(Configuration.shared.oauth.issuer.host ?? "Unknown")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                    
                    HStack {
                        Image(systemName: "key.fill")
                            .foregroundColor(.red)
                        Text("Client ID")
                        Spacer()
                        Text(String(Configuration.shared.oauth.clientID.prefix(8)) + "...")
                            .foregroundColor(.secondary)
                            .font(.caption)
                    }
                }
                
                Section {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(.blue)
                            Text("Help & Support")
                        }
                    }
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(.green)
                            Text("Terms of Service")
                        }
                    }
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.orange)
                            Text("Privacy Policy")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

#Preview {
    SettingsView()
}