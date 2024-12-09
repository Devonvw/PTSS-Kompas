//
//  ForgotPasswordReset.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 09/12/2024.
//

struct ForgotPasswordReset: Codable, ExampleProvidable {
    let resetCode: String
    let newPassword: String

    static let example: ForgotPasswordReset = .init(
        resetCode: "123456",
        newPassword: "NewPassword123!"
    )
}
