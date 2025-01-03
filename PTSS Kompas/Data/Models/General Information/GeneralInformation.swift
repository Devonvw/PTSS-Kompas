//
//  GeneralInformation.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/12/2024.
//

struct GeneralInformation: Codable, Identifiable, ExampleProvidable {
    let id: String
    let title: String
    let content: String
    let media: Media?

    static let example: GeneralInformation = .init(
        id: "00cf61f5-f708-45ef-b73e-88bcadccf8bb",
        title: "Wat is PTSS?",
        content: "Posttraumatische stressstoornis (PTSS) is een psychische aandoening...",
        media: Media.example
    )
}
