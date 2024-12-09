//
//  UserInviteVerify.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 09/12/2024.
//

struct UserInviteVerify: Codable, ExampleProvidable {
    let email: String
    let invitationCode: String

    static let example: UserInviteVerify = .init(
        email: "jan.dejong@email.nl",
        invitationCode: "123456"
    )
}
