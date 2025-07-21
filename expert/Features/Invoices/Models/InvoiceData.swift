//
//  InvoiceData.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import Foundation

struct InvoiceData: Codable {
    let invoices: [Invoice]?
    
    enum CodingKeys: String, CodingKey {
        case invoices = "invoices"
    }
}

struct Invoice: Codable, Identifiable {
    let id: String
    let title: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case createdAt = "created_at"
    }
}
