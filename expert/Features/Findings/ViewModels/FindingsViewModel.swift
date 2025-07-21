//
//  FindingsViewModel.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import Foundation
import SwiftUI

@MainActor
class FindingsViewModel: ObservableObject {
    @Published var findings: [Finding] = []
    @Published var isLoadingFindings: Bool = true
    
    private let authManager = AuthenticationManager.shared
    
    var currentUser: UserInfo? {
        authManager.currentUser
    }
    
    var isAuthenticated: Bool {
        authManager.isAuthenticated
    }
    
    init() {
        loadFindingsData()
    }
    
    func loadFindingsData() {
        Task {
            do {
                // Fetch dashboard data from API
                let findingsData = try await APIClient.shared.get(
                    "/api/findings",
                    type: FindingData.self
                )
                
                await MainActor.run {
                    self.findings = findingsData.findings ?? []
                    self.isLoadingFindings = false
                }
            } catch {
                await MainActor.run {
                    self.findings = []
                    self.isLoadingFindings = false
                }
            }
        }
    }
    
    func refreshData() {
        loadFindingsData()
    }
}
