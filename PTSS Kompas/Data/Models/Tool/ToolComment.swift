//
//  ToolComment.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/12/2024.
//

struct ToolComment: Codable, Identifiable, ExampleProvidable {
    let id: String
    let content: String
    let SenderId: String
    let SenderName: String
    let createdAt: String

    static let example: ToolComment = .init(
        id: "123e4567-e89b-12d3-a456-426614174000",
        content: "Oefening nogmaals gedaan, dit keer na tijdens een paniek aanval, wel keihard uitgelachen...",
        SenderId: "123e4567-e89b-12d3-a456-426614174000",
        SenderName: "Peter van Dijk",
        createdAt: "2024-01-01T10:00:00Z"
    )
}
