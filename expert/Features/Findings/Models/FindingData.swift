//
//  FindingData.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import Foundation

struct FindingData: Codable {
    let findings: [Finding]?
    
    enum CodingKeys: String, CodingKey {
        case findings = "findings"
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
