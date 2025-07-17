//
//  DashboardData.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import Foundation

struct DashboardData: Codable {
    let findingsCount: Int
    let openInvoicesCount: Int
    let recentFindings: [Finding]?
    let promos: [PromoData]?
    
    enum CodingKeys: String, CodingKey {
        case findingsCount = "findings_count"
        case openInvoicesCount = "open_invoices_count"
        case recentFindings = "recent_findings"
        case promos
    }
}

struct Finding: Codable, Identifiable {
    let id: String
    let title: String
    let status: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case status
        case createdAt = "created_at"
    }
}

struct PromoData: Codable, Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let iconName: String
    let colorHex: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case iconName = "icon_name"
        case colorHex = "color_hex"
    }
}