//
//  ContentView.swift
//  expert
//
//  Created by Tobias Oitzinger on 16.07.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authManager = AuthenticationManager.shared
    @StateObject private var findingsViewModel = FindingsViewModel()
    @StateObject private var homeViewModel = HomeViewModel()
    @StateObject private var invoicesViewModel = InvoicesViewModel()

    var body: some View
    {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            
            if authManager.isAuthenticated {
                TabView {
                    Tab("tab.home".localized, systemImage: "house.fill") {
                        AuthenticatedViewWrapper(content: {
                            HomeView(viewModel: homeViewModel)
                        }, onRefresh: {
                            await homeViewModel.refreshData()
                        })
                    }

                    Tab("tab.findings".localized, systemImage: "doc.text.magnifyingglass") {
                        AuthenticatedViewWrapper(content: {
                            FindingsView(viewModel: findingsViewModel)
                        }, onRefresh: {
                            await findingsViewModel.refreshData()
                        })
                    }

                    Tab("tab.invoices".localized, systemImage: "doc.text.fill") {
                        AuthenticatedViewWrapper(content: {
                            InvoicesView(viewModel: invoicesViewModel)
                        }, onRefresh: {
                            await invoicesViewModel.refreshData()
                        })
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
