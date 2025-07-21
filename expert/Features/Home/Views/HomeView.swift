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
        VStack(spacing: 16) {
            // Promo Carousel
            PromoCarousel(currentIndex: $currentPromoIndex)
                .frame(height: 180)
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
        }
        .navigationTitle("tab.home".localized)
        .refreshable {
            viewModel.refreshData()
        }
    }
}


#Preview {
    HomeView()
}
