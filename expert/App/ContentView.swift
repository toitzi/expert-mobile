//
//  ContentView.swift
//  expert
//
//  Created by Tobias Oitzinger on 16.07.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    @State private var showMainView = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background color to ensure proper rendering
                Color(.systemBackground)
                    .ignoresSafeArea()
                
                if showMainView {
                    MainView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing).combined(with: .opacity),
                            removal: .move(edge: .trailing).combined(with: .opacity)
                        ))
                        .zIndex(1)
                } else {
                    SplashView()
                        .transition(.asymmetric(
                            insertion: .move(edge: .leading).combined(with: .opacity),
                            removal: .move(edge: .leading).combined(with: .opacity)
                        ))
                        .zIndex(0)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .animation(.easeInOut(duration: 0.5), value: showMainView)
        .onChange(of: authManager.isAuthenticated) { oldValue, newValue in
            // Small delay to ensure proper rendering
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation {
                    showMainView = newValue
                }
            }
        }
        .onAppear {
            // Set initial state without animation
            showMainView = authManager.isAuthenticated
        }
    }
}

#Preview {
    ContentView()
}
