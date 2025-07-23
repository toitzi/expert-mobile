//
//  FindingData.swift
//  expert
//
//  Created by Tobias Oitzinger on 17.07.25.
//

import Foundation

struct FindingData: Codable {
    let data: [Finding]
    let meta: MetaData

    var findings: [Finding]? {
        return data
    }
    
    enum CodingKeys: String, CodingKey {
        case data
        case meta
    }
}

struct Finding: Codable, Identifiable {
    let id: Int
    let title: String
    let date: String

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case date
    }
}
