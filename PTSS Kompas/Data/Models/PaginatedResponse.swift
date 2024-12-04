//
//  PaginatedResponse.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 04/12/2024.
//

struct PaginatedResponse<T: Codable & ExampleProvidable>: Codable, ExampleProvidable {
    let data: [T]
    let pagination: Pagination

    static var example: PaginatedResponse {
        .init(
            data: [T.example],
            pagination: Pagination.example
        )
    }
}

