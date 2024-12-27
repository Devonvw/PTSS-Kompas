//
//  ToolCategory.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/12/2024.
//

struct ToolCategory: Codable, Identifiable, ExampleProvidable {
    let id: String
    let name: String
    let createdAt: String
    let tools: [Tool]

    static let example: ToolCategory = .init(
        id: "category-1",
        name: "5-4-3-2-1 Methode",
        createdAt: "2024-01-01T10:00:00Z",
        tools: [
            Tool.example
        ]
    )
}
