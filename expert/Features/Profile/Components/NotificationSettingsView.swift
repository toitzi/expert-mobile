//
//  NotificationSettingsView.swift
//  expert
//
//  Created by Tobias Oitzinger on 22.07.25.
//

import SwiftUI
import UserNotifications

struct NotificationSettingsView: View {
    @State private var notificationsEnabled = false
    @State private var notificationsDenied = false
    @State private var findingsNotificationsEnabled = true
    @State private var invoicesNotificationsEnabled = true
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground)
                .ignoresSafeArea()
            
            List {
            // Only show enable section if notifications are not already enabled
            if !notificationsEnabled {
                Section {
                    Button(action: {
                        requestNotificationPermission()
                    }) {
                        Text(notificationsDenied ? "profile.allow_notifications".localized : "profile.enable_notifications".localized)
                            .foregroundColor(Color(.label))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .buttonStyle(PlainButtonStyle())
                } footer: {
                    if notificationsDenied {
                        Text("profile.notifications_disabled_help".localized)
                            .font(.caption)
                            .foregroundColor(Color(.secondaryLabel))
                    }
                }
            }
            
            Section {
                // Findings toggle
                Toggle(isOn: $findingsNotificationsEnabled) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("profile.findings_notifications".localized)
                        Text("profile.findings_notifications_description".localized)
                            .font(.caption)
                            .foregroundColor(Color(.secondaryLabel))
                    }
                }
                .disabled(!notificationsEnabled)
            }
            
            Section {
                // Invoices toggle
                Toggle(isOn: $invoicesNotificationsEnabled) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("profile.invoices_notifications".localized)
                        Text("profile.invoices_notifications_description".localized)
                            .font(.caption)
                            .foregroundColor(Color(.secondaryLabel))
                    }
                }
                .disabled(!notificationsEnabled)
            } footer: {
                Text("profile.notifications_privacy_notice".localized)
                    .font(.caption)
                    .foregroundColor(Color(.secondaryLabel))
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            }
        }
        .navigationTitle("profile.notifications".localized)
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Label("common.back".localized, systemImage: "chevron.left")
                        .labelStyle(.iconOnly)
                        .frame(width: 50, height: 50)
                }
            }
        }
        .onAppear {
            checkNotificationStatus()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { _ in
            checkNotificationStatus()
        }
    }
    
    private func checkNotificationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                notificationsEnabled = settings.authorizationStatus == .authorized
                notificationsDenied = settings.authorizationStatus == .denied
            }
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    // Request permission
                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                        DispatchQueue.main.async {
                            notificationsEnabled = granted
                            notificationsDenied = !granted
                        }
                    }
                case .denied:
                    // Open settings directly
                    if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings)
                    }
                case .authorized:
                    // Already authorized
                    notificationsEnabled = true
                    notificationsDenied = false
                case .provisional, .ephemeral:
                    // Handle provisional/ephemeral authorization
                    notificationsEnabled = true
                    notificationsDenied = false
                @unknown default:
                    break
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        NotificationSettingsView()
    }
}
