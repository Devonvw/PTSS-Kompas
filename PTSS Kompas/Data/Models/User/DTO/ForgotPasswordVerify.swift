//
//  ForgotPasswordVerify.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 09/12/2024.
//

struct ForgotPasswordVerify: Codable, ExampleProvidable {
    let email: String
    let resetCode: String

    static let example: ForgotPasswordVerify = .init(
        email: "jan.dejong@email.nl",
        resetCode: "123456"
    )
}
