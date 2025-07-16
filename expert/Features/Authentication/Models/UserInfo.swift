//
//  UserInfo.swift
//  expert
//
//  Created by Tobias Oitzinger on 16.07.25.
//

import Foundation

struct UserInfo: Codable {
    let id: String
    let name: String
    let email: String
    let username: String?
    let emailVerifiedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case username
        case emailVerifiedAt = "email_verified_at"
    }
    
    var displayName: String {
        if !name.isEmpty {
            return name
        }
        
        return username ?? email
    }
    
    var initials: String {
        let components = name.split(separator: " ")
        if components.count >= 2 {
            // First and last name initials
            return "\(components.first?.first?.uppercased() ?? "")\(components.last?.first?.uppercased() ?? "")"
        } else if !name.isEmpty {
            // Single name - take first two characters
            let firstTwo = name.prefix(2).uppercased()
            return String(firstTwo)
        } else if let username = username, !username.isEmpty {
            // Use username initials
            return String(username.prefix(2).uppercased())
        } else {
            // Use email
            return String(email.prefix(2).uppercased())
        }
    }
}
