//
//  Login.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 09/12/2024.
//

struct Login: Codable, ExampleProvidable {
    let email: String
    let password: String

    static let example: Login = .init(
        email: "jan.dejong@email.nl",
        password: "Password123!"
    )
}
