//
//  HomeView.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if authManager.isAuthenticated {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text("Welcome back,")
                                        .font(.title2)
                                        .foregroundColor(.secondary)
                                    
                                    if let user = authManager.currentUser {
                                        Text(user.displayName)
                                            .font(.largeTitle)
                                            .fontWeight(.bold)
                                    }
                                }
                                
                                Spacer()
                                
                                ProfileIconView(userInfo: authManager.currentUser, size: 60)
                            }
                            .padding(.horizontal)
                            .padding(.top)
                            
                            VStack(spacing: 16) {
                                DashboardCard(
                                    title: "Recent Activity",
                                    icon: "clock.arrow.circlepath",
                                    color: .blue
                                ) {
                                    Text("No recent activity")
                                        .foregroundColor(.secondary)
                                        .padding()
                                }
                                
                                DashboardCard(
                                    title: "Quick Actions",
                                    icon: "bolt.fill",
                                    color: .orange
                                ) {
                                    VStack(spacing: 12) {
                                        QuickActionButton(
                                            title: "Refresh Token",
                                            icon: "arrow.clockwise",
                                            action: {
                                                Task {
                                                    await authManager.refreshToken()
                                                }
                                            }
                                        )
                                    }
                                    .padding()
                                }
                                
                                DashboardCard(
                                    title: "Statistics",
                                    icon: "chart.bar.fill",
                                    color: .green
                                ) {
                                    Text("Coming soon...")
                                        .foregroundColor(.secondary)
                                        .padding()
                                }
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        VStack(spacing: 20) {
                            Image(systemName: "person.crop.circle.badge.exclamationmark")
                                .font(.system(size: 80))
                                .foregroundColor(.secondary)
                            
                            Text("Not Authenticated")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("Please log in to access your dashboard")
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
            .navigationBarHidden(true)
        }
    }
}

struct DashboardCard<Content: View>: View {
    let title: String
    let icon: String
    let color: Color
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
            }
            
            content()
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
    }
}

struct QuickActionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                Text(title)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
        }
    }
}

#Preview {
    HomeView()
}