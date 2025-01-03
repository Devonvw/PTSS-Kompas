//
//  UpdateToolComment.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/12/2024.
//

struct UpdateToolComment: Codable, ExampleProvidable {
    let content: String

    static let example: UpdateToolComment = .init(
        content: "Gewijzigde inhoud van de opmerking."
    )
}
