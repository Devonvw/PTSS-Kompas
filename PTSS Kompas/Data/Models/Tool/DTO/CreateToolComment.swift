//
//  CreateToolComment.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/12/2024.
//

struct CreateToolComment: Codable, ExampleProvidable {
    let content: String

    static let example: CreateToolComment = .init(
        content: "Het opschrijven van positieve gedachten in het dagboek..."
    )
}
