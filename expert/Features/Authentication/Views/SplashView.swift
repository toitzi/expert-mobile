//
//  SplashView.swift
//  expert
//
//  Created by Tobias Oitzinger on 16.07.25.
//

import SwiftUI

struct SplashView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                if authManager.isAuthenticated {
                    VStack(spacing: 20) {
                        ProfileIconView(userInfo: authManager.currentUser, size: 80)
                            .padding(.bottom, 10)
                        
                        if let user = authManager.currentUser {
                            Text("Hello, \(user.displayName)!")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        } else {
                            // Skeleton for text while loading
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 200, height: 40)
                                .shimmering()
                        }
                        
                        if let accessToken = authManager.getAccessToken() {
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Access Token:")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text(accessToken)
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.7))
                                    .lineLimit(5)
                                    .truncationMode(.tail)
                                    .padding()
                                    .background(Color.black.opacity(0.3))
                                    .cornerRadius(8)
                                    .textSelection(.enabled)
                            }
                            .frame(maxWidth: 300)
                        }
                    }
                    
                    HStack(spacing: 15) {
                        Button(action: {
                            Task {
                                await authManager.refreshToken()
                            }
                        }) {
                            HStack {
                                if authManager.isRefreshing {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Text("Refresh")
                                        .font(.headline)
                                }
                            }
                            .foregroundColor(.white)
                            .frame(width: 90, height: 50)
                            .background(Color.blue.opacity(authManager.isRefreshing ? 0.5 : 0.8))
                            .cornerRadius(10)
                        }
                        .disabled(authManager.isRefreshing)
                        
                        Button(action: {
                            authManager.logout()
                        }) {
                            Text("Logout")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(width: 90, height: 50)
                                .background(Color.red.opacity(0.8))
                                .cornerRadius(10)
                        }
                    }
                } else {
                    VStack(spacing: 20) {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .foregroundColor(.white)
                        
                        Text("Welcome to Expert")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text("Please log in to continue")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    Button(action: {
                        authManager.login()
                    }) {
                        HStack {
                            if authManager.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Text("Login with OAuth")
                                    .font(.headline)
                            }
                        }
                        .foregroundColor(.white)
                        .frame(width: 200, height: 50)
                        .background(Color.green.opacity(0.8))
                        .cornerRadius(10)
                    }
                    .disabled(authManager.isLoading)
                }
            }
            .padding()
        }
    }
}