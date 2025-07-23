//
//  MetaData.swift
//  expert
//
//  Created by Tobias Oitzinger on 23.07.25.
//
struct MetaData: Codable {
    let perPage: Int?
    let nextCursor: String?
    let prevCursor: String?

    enum CodingKeys: String, CodingKey {
        case perPage = "per_page"
        case nextCursor = "next_cursor"
        case prevCursor = "prev_cursor"
    }
}
