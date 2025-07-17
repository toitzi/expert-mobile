//
//  ProfileView.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if authManager.isAuthenticated {
                        VStack(spacing: 16) {
                            ProfileIconView(userInfo: authManager.currentUser, size: 120)
                            
                            if let user = authManager.currentUser {
                                VStack(spacing: 8) {
                                    Text(user.displayName)
                                        .font(.title)
                                        .fontWeight(.bold)
                                    
                                    Text(user.email)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                        .padding(.top)
                        
                        VStack(spacing: 16) {
                            if let user = authManager.currentUser {
                                ProfileInfoSection(title: "Account Information") {
                                    Group {
                                        ProfileInfoRow(label: "User ID", value: user.id)
                                        ProfileInfoRow(label: "Username", value: user.username ?? "None")
                                        ProfileInfoRow(label: "Email", value: user.email)
                                    }
                                }
                            }
                            ProfileInfoSection(title: "Authentication") {
                                Button(action: {
                                    Task {
                                        await authManager.refreshToken()
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: "arrow.clockwise")
                                        Text("Refresh Token")
                                    }
                                    .foregroundColor(.blue)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(10)
                                }
                                .disabled(authManager.isRefreshing)
                            }
                            
                            Button(action: {
                                authManager.logout()
                            }) {
                                HStack {
                                    Image(systemName: "arrow.right.square")
                                    Text("Logout")
                                }
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red.opacity(0.1))
                                .cornerRadius(10)
                            }
                        }
                        .padding()
                    } else {
                        VStack(spacing: 20) {
                            Image(systemName: "person.crop.circle")
                                .font(.system(size: 100))
                                .foregroundColor(.secondary)
                            
                            Text("Not Logged In")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("Please log in to view your profile")
                                .foregroundColor(.secondary)
                            
                            Button(action: {
                                authManager.login()
                            }) {
                                Text("Login")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .frame(width: 200, height: 50)
                                    .background(Color.blue)
                                    .cornerRadius(10)
                            }
                        }
                        .frame(maxHeight: .infinity)
                        .padding()
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ProfileInfoSection<Content: View>: View {
    let title: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .padding(.horizontal)
            
            VStack(spacing: 0) {
                content()
            }
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .padding(.horizontal)
        }
    }
}

struct ProfileInfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
    }
}

#Preview {
    ProfileView()
}
