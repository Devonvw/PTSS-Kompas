//
//  PaginatedResponse.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 04/12/2024.
//

struct PaginatedResponse<T: Codable & ExampleProvidable, P: Codable & ExampleProvidable>: Codable, ExampleProvidable {
    let data: [T]
    let pagination: P

    static var example: PaginatedResponse {
        .init(
            data: [T.example],
            pagination: P.example
        )
    }
}
