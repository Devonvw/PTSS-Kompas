//
//  GeneralInformationItem.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/12/2024.
//

struct GeneralInformationItem: Codable, Identifiable, ExampleProvidable {
    let id: String
    let title: String

    static let example: GeneralInformationItem = .init(
        id: "00cf61f5-f708-45ef-b73e-88bcadccf8bb",
        title: "Wat is PTSS?"
    )
}
