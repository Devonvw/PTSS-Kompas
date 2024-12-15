//
//  UserInviteCreate.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 09/12/2024.
//

struct UserInviteCreate: Codable, ExampleProvidable {
    let email: String

    static let example: UserInviteCreate = .init(
        email: "jan.dejong@email.nl"
    )
}
