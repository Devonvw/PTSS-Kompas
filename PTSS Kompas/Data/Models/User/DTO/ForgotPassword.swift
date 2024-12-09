//
//  ForgotPassword.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 09/12/2024.
//

struct ForgotPassword: Codable, ExampleProvidable {
    let email: String

    static let example: ForgotPassword = .init(
        email: "jan.dejong@email.nl"
    )
}
