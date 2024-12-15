//
//  Pagination.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 28/11/2024.
//

struct Pagination: Codable, ExampleProvidable {
    let nextCursor: String
    let pageSize: Int
    let totalItems: Int
    let totalPages: Int
    
    static let example: Pagination = .init(
        nextCursor: "asdasd", pageSize: 100, totalItems: 10, totalPages: 1
    )
}

struct BiDirectionalPagination: Codable, ExampleProvidable {
    let nextCursor: String
    let previousCursor: String
    let pageSize: Int
    let totalItems: Int
    let totalPages: Int
    
    static let example: BiDirectionalPagination = .init(
        nextCursor: "asdasd", previousCursor: "asdasd", pageSize: 100, totalItems: 10, totalPages: 1
    )
}

enum PageDirection: String {
    case Next = "next"
    case Previous = "previous"
}
