//
//  UserRegister.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 09/12/2024.
//

struct UserRegister: Codable, ExampleProvidable {
    let firstName: String
    let lastName: String
    let password: String
    let repeatPassword: String
    let invitationCode: String
    let email: String

    static let example: UserRegister = .init(
        firstName: "Jan",
        lastName: "de Jong",
        password: "Password123!",
        repeatPassword: "Password123!",
        invitationCode: "123456",
        email: "jan@dejong.com"
    )
}
