//
//  PinLogin.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 09/12/2024.
//

struct PinLogin: Codable, ExampleProvidable {
    let pin: String

    static let example: PinLogin = .init(
        pin: "1234"
    )
}
