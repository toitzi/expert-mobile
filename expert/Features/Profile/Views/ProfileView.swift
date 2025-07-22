//
//  ProfileView.swift
//  expert
//
//  Created by Tobias Oitzinger on 19.07.25.
//

import SwiftUI

struct ProfileView: View {
    @Binding var isPresented: Bool
    @State private var showingLogoutAlert = false
    @StateObject private var authManager = AuthenticationManager.shared
    
    private var languageCode: String {
        let locale = Locale.current
        let language = locale.language.languageCode?.identifier ?? "en"
        
        // Use "de" for German and Swiss German, "en" for everything else
        return (language == "de" || language == "gsw") ? "de" : "en"
    }
    
    var body: some View {
        NavigationStack {
            List {
                // Account Section
                Section {
                    NavigationLink(destination: Text("Payment Methods")) {
                        Text("settings.payment_methods".localized)
                    }
                }
                
                // General Section
                Section {
                    NavigationLink(destination: NotificationSettingsView()) {
                        Text("profile.notifications".localized)
                    }
                }
                
                // Support Section
                Section {
                    Button(action: {
                        if let url = URL(string: "https://expert.emergencyradiology.ch/\(languageCode)/agb") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("settings.terms_of_service".localized)
                    }
                    
                    Button(action: {
                        if let url = URL(string: "https://expert.emergencyradiology.ch/\(languageCode)/privacy") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("settings.privacy_policy".localized)
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
            .navigationTitle("profile.title".localized)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        isPresented = false
                    }
                    label: {
                        Label("common.close".localized, systemImage: "xmark")
                            .labelStyle(.iconOnly)
                            .frame(width: 50, height: 50)
                    }
                    .glassEffect()
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
        .presentationDetents([.large])
        .presentationDragIndicator(.hidden)
        .presentationCornerRadius(20)
    }
}

#Preview {
    ProfileView(isPresented: .constant(true))
}
