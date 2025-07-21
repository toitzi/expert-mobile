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
            // Background gradient
            VStack(spacing: 0) {
                Color(.systemBackground)
                    .frame(maxHeight: .infinity)
                
                // Three-layer fade effect
                ZStack(alignment: .bottom) {
                    // Lightest layer
                    Color.accentColor.opacity(0.15)
                        .frame(height: UIScreen.main.bounds.height * 0.52)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 150,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 150
                            )
                        )
                    
                    // Medium layer
                    Color.accentColor.opacity(0.4)
                        .frame(height: UIScreen.main.bounds.height * 0.49)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 140,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 140
                            )
                        )
                    
                    // Main accent color
                    Color.accentColor
                        .frame(height: UIScreen.main.bounds.height * 0.46)
                        .clipShape(
                            .rect(
                                topLeadingRadius: 130,
                                bottomLeadingRadius: 0,
                                bottomTrailingRadius: 0,
                                topTrailingRadius: 130
                            )
                        )
                }
            }
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                    .frame(height: UIScreen.main.bounds.height * 0.045)
                
                // Logo
                Image("ERSLogo")
                    .resizable()
                    .renderingMode(.original)
                    .scaledToFit()
                    .frame(width: 342, height: 342)
                
                Spacer()
                
                // Welcome text
                VStack(spacing: 12) {
                    Text("Welcome")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.label))
                    
                    Text("Your Digital Health Assistant,\nAlways at Your Service")
                        .font(.body)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(.label).opacity(0.9))
                }
                .padding(.bottom, 60)
                
                // Login Button
                Button(action: {
                    authManager.login()
                }) {
                    HStack(spacing: 12) {
                        if authManager.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .accentColor))
                                .scaleEffect(0.8)
                        } else {
                            Image("XcoorpLogo")
                                .resizable()
                                .renderingMode(.original)
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                            
                            Text("Continue with Xcoorp ID")
                                .font(.body)
                                .fontWeight(.medium)
                        }
                    }
                    .foregroundColor(Color(.accent))
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color(.label))
                    .cornerRadius(25)
                }
                .disabled(authManager.isLoading)
                .padding(.horizontal, 40)
                
                Spacer()
                    .frame(height: 100)
            }
        }
    }
}
