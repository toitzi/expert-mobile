//
//  InvoicesViewModel.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import Foundation
import SwiftUI

@MainActor
class InvoicesViewModel: ObservableObject {
    @Published var invoices: [Invoice] = []
    @Published var isLoadingInvoices: Bool = true
    
    private let authManager = AuthenticationManager.shared
    
    var currentUser: UserInfo? {
        authManager.currentUser
    }
    
    var isAuthenticated: Bool {
        authManager.isAuthenticated
    }
    
    init() {
        loadInvoiceData()
    }
    
    func loadInvoiceData() {
        Task {
            do {
                // Fetch dashboard data from API
                let invoiceData = try await APIClient.shared.get(
                    "/api/invoices",
                    type: InvoiceData.self
                )
                
                await MainActor.run {
                    self.invoices = invoiceData.invoices ?? []
                    self.isLoadingInvoices = false
                }
            } catch {
                await MainActor.run {
                    self.invoices = []
                    self.isLoadingInvoices = false
                }
            }
        }
    }
    
    func refreshData() {
        loadInvoiceData()
    }
}
