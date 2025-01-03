//
//  EmergencyContact.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 27/12/2024.
//

struct EmergencyContact: Codable, Identifiable, ExampleProvidable {
    let id: String
    let name: String
    let phoneNumber: String
    let actionLabel: String

    static let example: EmergencyContact = .init(
        id: "7aff44ec-5a02-4866-aad3-52c6ad4d1cbc",
        name: "Levensbedreigende situatie? Bel 112",
        phoneNumber: "112",
        actionLabel: "Bel direct met 112"
    )
}
