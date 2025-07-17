//
//  HomeViewModel.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import Foundation
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @Published var findingsCount: Int = 0
    @Published var openInvoicesCount: Int = 0
    @Published var isLoadingCounters: Bool = true
    
    private let authManager = AuthenticationManager.shared
    
    var currentUser: UserInfo? {
        authManager.currentUser
    }
    
    var isAuthenticated: Bool {
        authManager.isAuthenticated
    }
    
    init() {
        loadDashboardData()
    }
    
    func loadDashboardData() {
        Task {
            isLoadingCounters = true
            
            do {
                // Fetch dashboard data from API
                let dashboardData = try await APIClient.shared.get(
                    "/api/dashboard",
                    type: DashboardData.self
                )
                
                await MainActor.run {
                    self.findingsCount = dashboardData.findingsCount
                    self.openInvoicesCount = dashboardData.openInvoicesCount
                    self.isLoadingCounters = false
                }
            } catch {
                print("Failed to load dashboard data: \(error)")
                
                // Fallback to mock data in case of error
                await MainActor.run {
                    self.findingsCount = Int.random(in: 5...20)
                    self.openInvoicesCount = Int.random(in: 0...10)
                    self.isLoadingCounters = false
                }
            }
        }
    }
    
    func refreshData() {
        loadDashboardData()
    }
    
    func requestNewFinding() {
        // TODO: Navigate to finding request screen
        print("Request new finding tapped")
    }
    
    func openFAQ() {
        // TODO: Navigate to FAQ screen
        print("FAQ tapped")
    }
}