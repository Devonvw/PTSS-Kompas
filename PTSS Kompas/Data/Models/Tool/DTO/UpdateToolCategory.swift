//
//  UpdateToolCategory.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/12/2024.
//

struct UpdateToolCategory: Codable, ExampleProvidable {
    let name: String

    static let example: UpdateToolCategory = .init(
        name: "Gewijzigde Categorie"
    )
}
