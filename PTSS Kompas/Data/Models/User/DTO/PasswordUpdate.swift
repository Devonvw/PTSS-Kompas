//
//  PasswordUpdate.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 09/12/2024.
//

struct PasswordUpdate: Codable, ExampleProvidable {
    let currentPassword: String
    let newPassword: String

    static let example: PasswordUpdate = .init(
        currentPassword: "Password123!",
        newPassword: "NewPassword123!"
    )
}
