//
//  PinUpdate.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 09/12/2024.
//

struct PinUpdate: Codable, ExampleProvidable {
    let currentPin: String
    let newPin: String

    static let example: PinUpdate = .init(
        currentPin: "1234",
        newPin: "4321"
    )
}
