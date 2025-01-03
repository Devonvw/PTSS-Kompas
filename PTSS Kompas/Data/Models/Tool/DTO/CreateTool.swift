//
//  ToolCreate.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/12/2024.
//

struct CreateTool: Codable, ExampleProvidable {
    let name: String
    let description: String
    let category: [String]

    static let example: CreateTool = .init(
        name: "Positief Dagboek",
        description: "Een dagelijkse schrijfoefening gericht op het reflecteren...",
        category: ["Schrijfoefening"]
    )
}
