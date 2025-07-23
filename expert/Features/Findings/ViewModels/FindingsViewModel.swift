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
    @Published var isLoadingFindings: Bool = false
    @Published var isLoadingMore: Bool = false
    @Published var hasMorePages: Bool = true
    
    private var nextCursor: String?
    private let pageSize = 15
    
    private let authManager = AuthenticationManager.shared
    
    var currentUser: UserInfo? {
        authManager.currentUser
    }
    
    var isAuthenticated: Bool {
        authManager.isAuthenticated
    }
    
    init() {
        // Don't load data in init when created as @StateObject in parent
    }
    
    func loadFindingsData(reset: Bool = false) {
        Task {
            // If resetting, clear existing data
            if reset {
                await MainActor.run {
                    self.findings = []
                    self.nextCursor = nil
                    self.hasMorePages = true
                    self.isLoadingFindings = true
                }
            }
            
            // Don't load if already loading or no more pages
            guard !isLoadingMore && hasMorePages else { return }
            
            await MainActor.run {
                if !reset {
                    self.isLoadingMore = true
                }
            }
            
            do {
                // Build query parameters
                var queryParams = "?limit=\(pageSize)"
                if let cursor = nextCursor, !reset {
                    queryParams += "&cursor=\(cursor)"
                }
                
                // Fetch paginated data from API
                let findingsData = try await ResourceAPIClient.shared.get(
                    "/api/findings\(queryParams)",
                    type: FindingData.self
                )
                
                await MainActor.run {
                    if reset {
                        self.findings = findingsData.data
                    } else {
                        self.findings.append(contentsOf: findingsData.data)
                    }
                    
                    self.nextCursor = findingsData.meta.nextCursor
                    self.hasMorePages = findingsData.meta.nextCursor != nil
                    self.isLoadingFindings = false
                    self.isLoadingMore = false
                }
            } catch {
                await MainActor.run {
                    if reset {
                        self.findings = []
                    }
                    self.isLoadingFindings = false
                    self.isLoadingMore = false
                    self.hasMorePages = false
                }
            }
        }
    }
    
    func loadMore() {
        guard !isLoadingMore && hasMorePages && nextCursor != nil else { return }
        loadFindingsData(reset: false)
    }
    
    func refreshData() async {
        loadFindingsData(reset: true)
    }
}
