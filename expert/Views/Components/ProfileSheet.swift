//
//  ProfileSheet.swift
//  expert
//
//  Created by Tobias Oitzinger on 19.07.25.
//

import SwiftUI

struct ProfileSheet: View {
    @Binding var isPresented: Bool
    @State private var notificationsEnabled = true
    @State private var showingLogoutAlert = false
    @StateObject private var authManager = AuthenticationManager.shared
    
    var body: some View {
        NavigationStack {
            List {
                // Account Section
                Section("settings.account".localized) {
                    NavigationLink(destination: Text("My Profile")) {
                        HStack {
                            Image(systemName: "person.circle.fill")
                                .foregroundColor(Color(.blue))
                            Text("settings.my_profile".localized)
                        }
                    }
                    
                    NavigationLink(destination: Text("Payment Methods")) {
                        HStack {
                            Image(systemName: "creditcard.fill")
                                .foregroundColor(Color(.green))
                            Text("settings.payment_methods".localized)
                        }
                    }
                    
                    NavigationLink(destination: Text("Address")) {
                        HStack {
                            Image(systemName: "location.fill")
                                .foregroundColor(Color(.accent))
                            Text("settings.address".localized)
                        }
                    }
                }
                
                // General Section
                Section("settings.general".localized) {
                    Toggle(isOn: $notificationsEnabled) {
                        HStack {
                            Image(systemName: "bell.fill")
                                .foregroundColor(Color(.blue))
                            Text("settings.notifications".localized)
                        }
                    }
                }
                
                // About Section
                Section("settings.about".localized) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(Color(.blue))
                        Text("settings.version".localized)
                        Spacer()
                        Text("1.0.0")
                            .foregroundColor(Color(.secondaryLabel))
                    }
                }
                
                // Support Section
                Section {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(Color(.blue))
                            Text("settings.help_support".localized)
                        }
                    }
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "doc.text.fill")
                                .foregroundColor(Color(.green))
                            Text("settings.terms_of_service".localized)
                        }
                    }
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(Color(.accent))
                            Text("settings.privacy_policy".localized)
                        }
                    }
                }
                
                // Logout Section
                Section {
                    Button(action: {
                        showingLogoutAlert = true
                    }) {
                        HStack {
                            Spacer()
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("settings.logout".localized)
                                .fontWeight(.medium)
                            Spacer()
                        }
                        .foregroundColor(Color(.red))
                    }
                }
            }
            .navigationTitle("tab.settings".localized)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("common.done".localized) {
                        isPresented = false
                    }
                }
            }
            .alert("settings.logout_confirmation_title".localized, isPresented: $showingLogoutAlert) {
                Button("common.cancel".localized, role: .cancel) { }
                Button("settings.logout".localized, role: .destructive) {
                    authManager.logout()
                }
            } message: {
                Text("settings.logout_confirmation_message".localized)
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .presentationCornerRadius(20)
    }
}

#Preview {
    ProfileSheet(isPresented: .constant(true))
}