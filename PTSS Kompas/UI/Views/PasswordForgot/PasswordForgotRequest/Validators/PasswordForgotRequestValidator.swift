//
//  CreateValidator.swift
//  PTSS Kompas
//
//  Created by Devon van Wichen on 05/12/2024.
//

import Foundation

struct PasswordForgetRequestValidator {
    func validate (_ forgotPassword: ForgotPassword) throws {
        if forgotPassword.email.isEmpty {
            throw ValidatorError.missingEmail
        }
        
        if isValidEmail(forgotPassword.email) == false {
            throw ValidatorError.invalidEmail
        }
    }
}

extension PasswordForgetRequestValidator {
    enum ValidatorError: LocalizedError {
        case missingEmail
        case invalidEmail
    }
}

extension PasswordForgetRequestValidator.ValidatorError {
    var errorDescription: String? {
        switch self {
        case .missingEmail:
            return "Vergeet niet jouw e-mail in te vullen"
        case .invalidEmail:
            return "Dit is geen correcte e-mail"
        }
    }
}
