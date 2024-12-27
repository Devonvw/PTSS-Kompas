//
//  Tool.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/12/2024.
//

struct Tool: Codable, Identifiable, ExampleProvidable {
    let id: String
    let name: String
    let description: String
    let createdBy: String
    let createdAt: String

    static let example: Tool = .init(
        id: "123e4567-e89b-12d3-a456-426614174000",
        name: "5-4-3-2-1 Methode",
        description: "Een praktische en effectieve...",
        createdBy: "Pricilla Simons",
        createdAt: "2024-01-01T10:00:00Z"
    )
}
