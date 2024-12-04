//
//  Pagination.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/11/2024.
//

struct Pagination: Codable {
    let nextCursor: String
    let pageSize: Int
    let totalItems: Int
    let totalPages: Int
    
    static let example: Pagination = .init(
        nextCursor: "asdasd", pageSize: 100, totalItems: 10, totalPages: 1
    )
}
