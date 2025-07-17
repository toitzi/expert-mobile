//
//  HomeView.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var currentPromoIndex = 0
    
    private let promoTimer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    if viewModel.isAuthenticated {
                        // Welcome Box
                        WelcomeBox(user: viewModel.currentUser)
                            .padding(.horizontal)
                            .padding(.top)
                        
                        // Promo Carousel
                        PromoCarousel(currentIndex: $currentPromoIndex)
                            .frame(height: 180)
                            .padding(.horizontal)
                            .onReceive(promoTimer) { _ in
                                withAnimation(.spring()) {
                                    currentPromoIndex = (currentPromoIndex + 1) % 3
                                }
                            }
                        
                        // Counter Widgets
                        HStack(spacing: 16) {
                            CounterWidget(
                                title: "home.findings".localized,
                                count: viewModel.findingsCount,
                                icon: "doc.text.magnifyingglass",
                                color: .purple
                            )
                            .redacted(reason: viewModel.isLoadingCounters ? .placeholder : [])
                            
                            CounterWidget(
                                title: "home.open_invoices".localized,
                                count: viewModel.openInvoicesCount,
                                icon: "doc.text.fill",
                                color: .orange
                            )
                            .redacted(reason: viewModel.isLoadingCounters ? .placeholder : [])
                        }
                        .padding(.horizontal)
                        
                        // Action Boxes
                        VStack(spacing: 16) {
                            ActionBox(
                                title: "home.request_finding".localized,
                                subtitle: "home.request_finding_subtitle".localized,
                                icon: "plus.circle.fill",
                                gradientColors: [.blue, .cyan]
                            ) {
                                viewModel.requestNewFinding()
                            }
                            
                            ActionBox(
                                title: "home.faq".localized,
                                subtitle: "home.faq_subtitle".localized,
                                icon: "questionmark.circle.fill",
                                gradientColors: [.green, .mint]
                            ) {
                                viewModel.openFAQ()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom)
                        
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
                                AuthenticationManager.shared.login()
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
            .background(Color(.systemGroupedBackground))
            .refreshable {
                viewModel.refreshData()
            }
        }
    }
}


#Preview {
    HomeView()
}