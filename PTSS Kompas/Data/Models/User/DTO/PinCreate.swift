//
//  PinCreate.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 09/12/2024.
//

struct PinCreate: Codable, ExampleProvidable {
    let pin: String

    static let example: PinCreate = .init(
        pin: "1234"
    )
}
