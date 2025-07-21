//
//  ContentView.swift
//  expert
//
//  Created by Tobias Oitzinger on 16.07.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager.shared

    var body: some View
    {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            if authManager.isAuthenticated {
                TabView {
                    Tab("tab.home".localized, systemImage: "house.fill") {
                        AuthenticatedViewWrapper {
                            HomeView()
                        }
                    }

                    Tab("tab.findings".localized, systemImage: "doc.text.magnifyingglass") {
                        AuthenticatedViewWrapper {
                            FindingsView()
                        }
                    }

                    Tab("tab.invoices".localized, systemImage: "doc.text.fill") {
                        AuthenticatedViewWrapper {
                            InvoicesView()
                        }
                    }
                }
                .tabBarMinimizeBehavior(.onScrollDown)
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .trailing).combined(with: .opacity)
                ))
                .zIndex(1)
            } else {
                SplashView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .trailing).combined(with: .opacity)
                    ))
                    .zIndex(1)
            }
        }
    }
}

#Preview {
    ContentView()
}
