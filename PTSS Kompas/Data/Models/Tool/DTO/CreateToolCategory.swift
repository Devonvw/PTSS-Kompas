//
//  CreateToolCategory.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/12/2024.
//

struct CreateToolCategory: Codable, ExampleProvidable {
    let name: String

    static let example: CreateToolCategory = .init(
        name: "Nieuwe Categorie"
    )
}
