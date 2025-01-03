//
//  PasswordUpdate.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 09/12/2024.
//

struct PasswordUpdate: Codable, ExampleProvidable {
    let currentPassword: String
    let newPassword: String
    let repeatNewPassword: String

    static let example: PasswordUpdate = .init(
        currentPassword: "Password123!",
        newPassword: "NewPassword123!",
        repeatNewPassword: "NewPassword123!"
    )
}
