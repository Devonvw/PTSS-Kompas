//
//  ToolResponse.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 13/01/2025.
//


struct ToolListItem: Codable, Identifiable, Hashable, ExampleProvidable {
    let id: String
    let name: String
    let createdBy: String?
    
    static let example: ToolListItem = .init(
        id: "123e4567-e89b-12d3-a456-426614174000",
        name: "5-4-3-2-1 Methode",
        createdBy: "Pricilla Simons"
    )
}
